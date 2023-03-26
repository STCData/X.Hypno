function drawObservationsMarkers(canvas, observations) {
    const ctx = canvas.getContext('2d');

    // Clear the canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    for (let obs of observations) {

        if (obs.bottomLeft && obs.bottomRight && obs.topLeft && obs.topRight) {
            // Draw a half-transparent rectangle
            ctx.fillStyle = 'rgba(233, 88, 0, 0.1)';
            ctx.fillRect(obs.bottomLeft.x, obs.bottomLeft.y, obs.bottomRight.x - obs.bottomLeft.x, obs.topLeft.y - obs.bottomLeft.y);

            // Add confidence and date in bottom left and bottom right respectively
            if (obs.confidence && obs.timestamp) {
                ctx.fillStyle = 'magent';
                ctx.font = '12px Arial';
                ctx.fillText(`📝`, obs.bottomRight.x - 7, obs.bottomRight.y + 15);
            }
        }


        if (obs.recognizedPoints) {
            // Draw circles for each point
            for (let id in obs.recognizedPoints) {
                const point = obs.recognizedPoints[id];
                const x = point.x;
                const y = point.y;
                const r = 5;
                // Draw the circle
                ctx.beginPath();
                ctx.arc(x, y, r, 0, 2 * Math.PI, false);
                ctx.fillStyle = 'green';
                ctx.fill();
                // Draw the confidence and identifier next to the point
                if (point.confidence && point.identifier) {
                    ctx.fillStyle = 'white';
                    ctx.font = '5px sans-serif';
                    ctx.fillText(`✌️ ${point.confidence.toFixed(2)}, ID: ${point.identifier}`, x + r + 5, y);
                }
            }
        }
    }
}

function drawObservationsLabel(canvas, observations) {
    const ctx = canvas.getContext('2d');
    const label = `Observations: ${observations.length}`;
    const centerX = canvas.width / 2;
    const bottomY = canvas.height - 20;
    ctx.font = 'bold 29px Arial';
    ctx.textAlign = 'center';
    ctx.fillStyle = '#09f00066';
    ctx.clearRect(0, bottomY - 25, canvas.width, 25);
    if (observations.length > 0) {
        ctx.fillText(label, centerX, bottomY);
    }

}

function drawObservations(observations) {
    const canvas = document.getElementById('my-canvas');
    if (canvas == null) {
        return
    };

    drawObservationsMarkers(canvas, observations);
    drawObservationsLabel(canvas, observations);
}


window.addEventListener('{{ JSObservationsEventName }}', function(ev) {
    
    if (!window.firstGeneratedCodeWasExecuted) {
        drawObservations(ev.detail.observations);
    }
});
