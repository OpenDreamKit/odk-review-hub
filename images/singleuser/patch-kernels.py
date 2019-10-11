import os
import glob
import json

for kernel_json in glob.glob(
    os.path.join(
        os.environ['SAGE_ROOT'],
        'local',
        'share',
        'jupyter',
        'kernels',
        '*',
        'kernel.json',
    )
):
    with open(kernel_json) as f:
        kernelspec = json.load(f)
    argv = kernelspec['argv']
    if os.path.basename(argv[0]).startswith("python"):
        old_argv = argv[:]
        argv[:1] = ["sage", "--python3"]
        print(f"patching {kernel_json}.argv: {old_argv} -> {argv}")
        with open(kernel_json, 'w') as f:
            json.dump(kernelspec, f, indent=1, sort_keys=True)
