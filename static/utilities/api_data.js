export const apiData = (room_code) => {
    
    async function getChartData() {
        const response = await fetch('/chart_data/' + room_code)
        const chartData = await response.json()

        return chartData
    }

    const int_data = getChartData()
    alert(" interim data: " + JSON.stringify(int_data))

    return int_data
}
