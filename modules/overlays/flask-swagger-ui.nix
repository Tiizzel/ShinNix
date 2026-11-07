{
  flake.aspects.base.nixos = { ... }: {
    # Fix upstream packaging bug in nixpkgs: flask-swagger-ui 5.32.14 uses pyproject.toml without setup.py
    nixpkgs.overlays = [
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pyFinal: pyPrev: {
            flask-swagger-ui = pyPrev.flask-swagger-ui.overridePythonAttrs (_: {
              format = null;
              pyproject = true;
              build-system = [ pyFinal.setuptools ];
            });
          })
        ];
      })
    ];
  };
}
