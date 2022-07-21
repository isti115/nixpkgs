{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numba
, numpy
, pytestCheckHook
, pyyaml
, rapidjson
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZlX6ItGx0dy5zO4NUCNQq5DFNGehC1QLdiRCK1lNLnI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ pyyaml rapidjson ];
  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  checkInputs = [ pytestCheckHook numba ];

  disabledTests = [
    # incomatible with numpy 1.23
    "test_numpyarray"
  ];

  disabledTestPaths = [ "tests-cuda" ];

  meta = with lib; {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
