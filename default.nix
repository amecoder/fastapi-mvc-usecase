{ lib
, python
, poetry2nix
}:

poetry2nix.mkPoetryApplication {
  inherit python;

  projectDir = ./.;
  pyproject = ./pyproject.toml;
  poetrylock = ./poetry.lock;

  pythonImportsCheck = [ "fastapi_mvc_usecase" ];

  meta = with lib; {
    homepage = "https://github.com/amecoder/fastapi-mvc-usecase.git";
    description = "This project was generated with fastapi-mvc.";
  };
}
