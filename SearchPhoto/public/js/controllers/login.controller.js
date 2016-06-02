angular.module('customerportal').controller('LoginController', function (Authentication, $rootScope, $location, $scope) {

	$scope.errorMessage = "";

	$scope.init = function () {
		$scope.loginPreloaderFlag = false;
        $scope.remember = Authentication.isRemember();
        $scope.remember = !$scope.remember ? {} : $scope.remember;

        if ($scope.remember.username) {
            $scope.username = $scope.remember.username;
            $scope.password = $scope.remember.password;
        }
	};

	$scope.getMessage = function () {
		return $scope.errorMessage;
	};

	$scope.login = function () {
		$scope.errorMessage = "";
		$scope.loginPreloaderFlag = true;

        if ($scope.remember.check) {
            Authentication.setRemember($scope.username, $scope.password);
        } else {
            Authentication.removeRemember($scope.username, $scope.password);
        }

		Authentication.login("/signin", { username: $scope.username, password: $scope.password },
			function (err, data) {
				data = err ? err : data;
				if ((data && !data.result) || (err && !err.result)) {
					$scope.errorMessage = data.message;
					$scope.loginPreloaderFlag = false;
				} else {
					Authentication.setAuthenticatedAccount($scope.username);
					window.location = data.redirect;
				}
			}
		);
	};


	$scope.logout = function () {
		Authentication.logout("/signout", {},
			function (err) {
				if (err) {
					console.error('Cannot Logout ' + err);
				}
				else {
					Authentication.unauthenticate();
					window.location = '/';
				}
			}
		);
	};

    $scope.resetModel = function () {
        $scope.errorMessage = "";
    };

    /******** Modal Close Event ********/
	$scope.resetModalParams = function () {
		$scope.resetModel();
		//$scope.idFunctionMap[modalId]();
    };

});