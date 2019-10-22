IMAGE=gcr.io/simula-odk/singleuser:2019
KUBE_CTX=odk
GKE_PROJECT=simula-odk
GKE_ZONE=europe-west1-b

.PHONY: image push

clean:
	chartpress --reset

image:
	chartpress

push:
	chartpress --push

upgrade:
	helm dep up ./jupyterhub
	make upgrade-quick

upgrade-quick:
	helm upgrade --install hub --kube-context=$(KUBE_CTX) ./jupyterhub -f secrets.yaml --namespace=hub

run:
	docker run -it --rm -p9999:8888 $(IMAGE) jupyter notebook --ip=0.0.0.0

pull:
	- $(foreach instance, \
		$(shell gcloud compute instances list --format json --project=$(GKE_PROJECT) | jq -r ".[].name"), \
		gcloud --project=$(GKE_PROJECT) compute ssh --zone=$(GKE_ZONE) $(instance) -- docker pull $(IMAGE);)

clean-jobs:
	kubectl --context=$(KUBE_CTX) delete jobs $(shell kubectl get jobs -a | sed '1d' | awk '{print $$1}')

conda-build:
	docker build -t odk-conda-build conda

conda: conda-build
	mkdir -p conda-pkgs
	docker run --rm -it -v $(shell pwd)/conda-pkgs:/io/pkgs odk-conda-build cp -nprv /opt/conda/conda-bld/linux-64/ /io/pkgs/

conda-upload: conda
	anaconda upload --skip-existing --label odk conda-pkgs/linux-64/*.tar.bz2
