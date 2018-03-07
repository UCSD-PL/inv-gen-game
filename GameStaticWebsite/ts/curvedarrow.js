(function ($) {
    $.fn.curvedArrow = function (options) {
        let settings = $.extend({
            p0x: 50,
            p0y: 50,
            p1x: 70,
            p1y: 10,
            p2x: 100,
            p2y: 100,
            size: 30,
            lineWidth: 5,
            strokeStyle: "rgba(125,242,125, 0.75)"
        }, options);
        let canvas = document.createElement("canvas");
        $(canvas).appendTo(this);
        let x_min_max = quadraticCurveMinMax(settings.p0x, settings.p1x, settings.p2x);
        let y_min_max = quadraticCurveMinMax(settings.p0y, settings.p1y, settings.p2y);
        let padding = settings.size - settings.lineWidth;
        let x_min = x_min_max[0] - padding;
        let x_max = x_min_max[1] + padding;
        let y_min = y_min_max[0] - padding;
        let y_max = y_min_max[1] + padding;
        let p0x = settings.p0x - x_min;
        let p0y = settings.p0y - y_min;
        let p1x = settings.p1x - x_min;
        let p1y = settings.p1y - y_min;
        let p2x = settings.p2x - x_min;
        let p2y = settings.p2y - y_min;
        canvas.style.position = "absolute";
        canvas.style.top = y_min + "px";
        canvas.style.left = x_min + "px";
        canvas.width = x_max - x_min;
        canvas.height = y_max - y_min;
        let ctx = canvas.getContext("2d");
        // Styling
        ctx.strokeStyle = settings.strokeStyle;
        ctx.lineWidth = settings.lineWidth;
        ctx.lineJoin = "round";
        ctx.lineCap = "round";
        // Arrow body
        ctx.beginPath();
        ctx.moveTo(p0x, p0y);
        ctx.quadraticCurveTo(p1x, p1y, p2x, p2y);
        ctx.stroke();
        // Arrow head
        let angle = Math.atan2(p2y - p1y, p2x - p1x);
        ctx.translate(p2x, p2y);
        // Right side
        ctx.rotate(angle + 1);
        ctx.beginPath();
        ctx.moveTo(0, settings.size);
        ctx.lineTo(0, 0);
        ctx.stroke();
        // Left side
        ctx.rotate(-2);
        ctx.lineTo(0, -settings.size);
        ctx.stroke();
        // Restore context
        ctx.rotate(1 - angle);
        ctx.translate(-p2x, -p2y);
        return $(canvas).addClass("curved_arrow");
    };
    function quadraticCurveMinMax(p0, p1, p2) {
        let min = p0;
        let max = p2;
        let t_step = 0.0001;
        for (let t = t_step; t <= 1; t += t_step) {
            let f = (1 - t) * (1 - t) * p0 + 2 * (1 - t) * t * p1 + (t * t * p2);
            if (f < min)
                min = f;
            if (f > max)
                max = f;
        }
        return [Math.round(min), Math.round(max)];
    }
}(jQuery));
//# sourceMappingURL=curvedarrow.js.map