'use strict';


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

