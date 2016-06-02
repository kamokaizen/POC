angular.module('customerportal').factory('CallService', function ($q, $http, $rootScope, $timeout, inform) {

	var timeout = 60 * 5 * 1000;
    function completeRequest(data, err, status, timeoutPromise, callback, heartbeatFlag) {
        $timeout.cancel(timeoutPromise);
        
		if (err && !err.status && (status === 401 || status === 403)){
			window.location = "/login";
		}
		else if(status !== 499) {
			err = status === -1 ? { result: false, message: 'Something went wrong. Please try again.' } : err;
			if (err) {
				var message = (err.message) ? err.message : "Something went wrong during service call";

				if (typeof message === 'string') {
					inform.add(message, {
						ttl: 5000, type: 'danger'
					});
				} else {
					_.each(message, function (msg) {
						inform.add(msg, {
							ttl: 5000, type: 'danger'
						});
					});
				}
			}

			if (err) {
				callback(err, null);
			} else {
				callback(null, data);
			}

			if (heartbeatFlag)
				return;

			$rootScope.postLoadingFlag = false;
			$rootScope.postLoadingDeleteFlag = false;
		}
    }

	// function checkLogin(err, status, callback) {
	// 	if (!err.status && (status == 401 || status == 403))
	// 		window.location = "/login";
	// 	else
	// 		callback(err, null);


	return {
        cancelPromises: [],
        download: function (url, params, callback) {
            var that = this;
            var defer = $q.defer();
            this.cancelPromises.push({ url: url, defer: defer });

            var timeoutPromise = $timeout(function () {
                defer.resolve(); // this aborts the request!
            }, timeout);

            $http.get(url, {
                params: params,
                timeout: defer.promise
            },  {responseType: 'arraybuffer'}).success(function (data, status) {
                completeRequest(data, null, status, timeoutPromise, callback);
				that.cancelPromises = _.without(that.cancelPromises, _.findWhere(that.cancelPromises, { defer: defer }));
            }).error(function (err, status, headers, config) {
                status = config.timeout.status ? config.timeout.status : status;
                completeRequest(null, err, status, timeoutPromise, callback);
				that.cancelPromises = _.without(that.cancelPromises, _.findWhere(that.cancelPromises, { defer: defer }));
            });
        },
		get: function (url, params, callback, heartbeatFlag) {
            var that = this;
            $rootScope.postLoadingFlag = true;

            var defer = $q.defer();
            this.cancelPromises.push({ url: url, defer: defer });

            var timeoutPromise = $timeout(function () {
                defer.resolve(); // this aborts the request!
            }, timeout);

			$http.get(url, {
				params: params,
				timeout: defer.promise
			}).success(function (data, status) {
                $timeout.cancel(timeoutPromise);
				completeRequest(data, null, status,timeoutPromise, callback, heartbeatFlag);
				that.cancelPromises = _.without(that.cancelPromises, _.findWhere(that.cancelPromises, { defer: defer }));
			}).error(function (err, status, headers, config) {
                status = config.timeout.status ? config.timeout.status : status;
				completeRequest(null, err, status, timeoutPromise, callback, heartbeatFlag);
				that.cancelPromises = _.without(that.cancelPromises, _.findWhere(that.cancelPromises, { defer: defer }));
			});
		},
		post: function (url, data, callback, deleteFlag) {
            var that = this;
			$rootScope.postLoadingFlag = true;

            var defer = $q.defer();
            this.cancelPromises.push({ url: url, defer: defer });

			if (deleteFlag)
				$rootScope.postLoadingDeleteFlag = true;

            var timeoutPromise = $timeout(function () {
                defer.resolve(); // this aborts the request!
            }, timeout);

			$http.post(url, data, { timeout: defer.promise })
				.success(function (data, status) {
                    $timeout.cancel(timeoutPromise);
					completeRequest(data, null, status,timeoutPromise, callback);
					that.cancelPromises = _.without(that.cancelPromises, _.findWhere(that.cancelPromises, { defer: defer }));
				}).error(function (err, status, headers, config) {
                    status = config.timeout.status ? config.timeout.status : status; 
					completeRequest(null, err, status, timeoutPromise, callback);
					that.cancelPromises = _.without(that.cancelPromises, _.findWhere(that.cancelPromises, { defer: defer }));
				});
		}
	};
});
