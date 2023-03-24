function updObs(observations) {

    const myEvent = new CustomEvent('{{ JSObservationsEventName }}', {
        detail: {
            observations: observations
        }
    });

    window.dispatchEvent(myEvent);
    //drawObservations(observations);

    const canvas = document.getElementById('my-canvas');
    if (canvas == null) {
        return
    };


    return {
        "{{ JSOutputKeysWidth }}": canvas.width,
        "{{ JSOutputKeysHeight }}": canvas.height
    }
}

updObs({{ observationsJson }});
