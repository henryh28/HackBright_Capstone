

function Homepage(props) {
    return (
        <React.Fragment>
            <div><h3>Home page link</h3></div>
        </React.Fragment>
    );
}

function CreateRoom(props) {     
    return (
        <React.Fragment>
            <div> Create a room</div>
        </React.Fragment>
    );
}

function Navbar() {
    return (
        <ReactRouterDOM.BrowserRouter>
            <ReactRouterDOM.Route exact path="/">
                <Homepage />
            </ReactRouterDOM.Route>
            <ReactRouterDOM.Route exact path="/leave_room">
                <CreateRoom />
            </ReactRouterDOM.Route>
        </ReactRouterDOM.BrowserRouter>
 
  );
}

ReactDOM.render(<Navbar />, document.getElementById('nav_bar'));


