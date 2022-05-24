
// Display voting results as charts

function draw_results(data) {
    const votes = []
    const titles = []

    for (const key in data) {
        if (key != 'chart_type') {
            titles.push(key)
            votes.push(data[key])    
        }        
    }


    const frame = document.getElementById("result_chart");

    const vote_result = new Chart(frame, {type: data['chart_type'], data: {
        labels: titles,
        datasets: [{
            label: document.title,
            data: votes,
            backgroundColor: [
                "rgba(250, 100, 100, 0.25)",
                "rgba(100, 150, 235, 0.25)",
                "rgba(150, 250, 150, 0.25)",
                "rgba(234, 155, 100, 0.25)",
                "rgba(200, 100, 200, 0.25)",
                "rgba(250, 250, 100, 0.25)",
                "rgba(125, 125, 125, 0.25)",
                ],
            borderColor: [
                "rgba(250, 100, 100, 1)",
                "rgba(100, 150, 235, 1)",
                "rgba(150, 250, 150, 1)",
                "rgba(234, 155, 100, 1)",
                "rgba(200, 100, 200, 1)",
                "rgba(250, 250, 100, 1)",
                "rgba(125, 125, 125, 1)",
                ]     

        }],
        options: {
            maintainAspectRatio: false,
            responsive: false, 
            scales: {
                y: {
                    stepSize: 1
                }
            }
        }
    }})



}
