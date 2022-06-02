'use strict';

// const { useState } = require("react");

// import { useEffect } from "react"
// import { Chart } from "../components/Chart";

function drawChart() {


    // Display voting results as charts


    React.useEffect(() => {
        const fetchData = async () => {
            const result = await fetch("/react_chart")
            const chartData = await result.json()

            console.log(chartData)

            const votes = []
            const titles = []
    
            for (const key in chartData) {
                if (key != 'chart_type') {
                    titles.push(key)
                    votes.push(data[key])    
                }        
            }



            setChartData({
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
                }]
            })

        }
        fetchData()
    }, []);

    // const [chartData, setChartData] = React.useState({})

    return (
        <React.Fragment>
            <div className="ReactChart">
                vote_result
            </div>
        </React.Fragment>
    );

}




function Test() {

    function click_test() {
        alert(" click testing 123")
    }
    
    return (
        <React.Fragment>
            <div class = "flex_container">
                <div class = "react_component">
                    Updated with react content
                </div>

                <div>
                    2nd column

                    <button onClick={()=> click_test()}>click testing</button>
                </div>
            </div>
        </React.Fragment>
    );
}

ReactDOM.render(<Test />, document.querySelector('#react_anchor'));
// ReactDOM.render(<drawChart />, document.querySelector('#react_anchor'));

