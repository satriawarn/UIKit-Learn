var Action = function() {}

Action.prototype = {
run: function(paremeters){
    parameters.completionFunction({"URL": document.URL, "title": document.title});
},
finalize: function(parameters){
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);
}
};

var ExtensionPreprocessingJS = new Action
