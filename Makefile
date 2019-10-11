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
	docker push $(IMAGE)

upgrade:
	helm dep up ./jupyterhub
	helm upgrade --install hub --kube-context=$(KUBE_CTX) ./jupyterhub -f config.yaml -f secrets.yaml --namespace=default

conda:
	docker build -t conda-pkgs conda-recipes

conda/%: conda
	- cd conda-recipes
	docker run --rm -it -v $(PWD)/conda-bld:/opt/conda/conda-bld -v $(PWD)/conda-recipes:/conda-recipes conda-pkgs conda build /conda-recipes/$*

run:
	docker run -it --rm -p9999:8888 $(IMAGE) jupyter notebook --ip=0.0.0.0

pull:
	- $(foreach instance, \
		$(shell gcloud compute instances list --format json --project=$(GKE_PROJECT) | jq -r ".[].name"), \
		gcloud --project=$(GKE_PROJECT) compute ssh --zone=$(GKE_ZONE) $(instance) -- docker pull $(IMAGE);)

clean-jobs:
	kubectl --context=$(KUBE_CTX) delete jobs $(shell kubectl get jobs -a | sed '1d' | awk '{print $$1}')
