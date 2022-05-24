'use strict';
alert ("who's first")

const e = React.createElement;

class WhateverYouWant extends React.Component {
  render () {
    return e(
      'div',
      null,
      'wait what?!'
    );
  }
}
const domContainer = document.querySelector('#root');
ReactDOM.render(e(WhateverYouWant), document.querySelector("#anchor"));