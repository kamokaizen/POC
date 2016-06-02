
exports.hasUndefinedParams = function(args) {
    var result = false;
    args.forEach(function(element) {
        if (typeof element === undefined) {
            result = true;
            return result;
        }
    }, this);
    return result;
};

exports.getBadRequestMessage = function(){
    return "Something went wrong while validating parameters";
}