var app = angular.module('app', [])

function changeDisplay(event) {
    if (window.innerWidth > 640 || event == 'onload') {
        angular.element(document.querySelectorAll(".image")).removeClass('noDisplay');
        angular.element(document.querySelectorAll(".text")).addClass('noDisplay');
    }
}

window.onresize = changeDisplay;

app.directive('display', function () {
    return {
        scope: false,
        link: function (scope, element, attrs) {
            element.on('click', function () {
                if (window.innerWidth < 641) {
                    element.parent().children().removeClass('noDisplay');
                    element.addClass('noDisplay');
                }
            })
        }
    }
})
