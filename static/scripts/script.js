/*
    const name = document.querySelector("#nameField").value;

    // Get skill that user typed in Skill field.
    const skill = document.querySelector("#skillField").value;

    fetch("/add-card", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ name, skill }),
      })
        .then((response) => response.json())
        .then((jsonResponse) => {
          const name = jsonResponse.cardAdded.name;
          const skill = jsonResponse.cardAdded.skill;
          const imgUrl = "/static/img/placeholder.png";
          createCardAndAddToContainer(name, skill, imgUrl);
        });
*/

function addItemToRoom(event) {
    alert (" -----> " + event.currentTarget.innerHTML);
    console.log(event.currentTarget.innerHTML)

    const requestOptions = {
        method: "POST",
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ })
    }

    fetch('/add_choice', requestOptions)
        .then(resonse => response.json())
        .then(data => console.log(data))

}


// Add event lister to search results
for (const result of document.querySelectorAll('.search_result_item')) {
    result.addEventListener("click", addItemToRoom)
}




// Navbar button to create a room
document.querySelector("#btn-create-room").addEventListener("click", () => {
    window.location = "/create_room";
})


// Navbar button to log user out
document.querySelector("#btn-logout").addEventListener("click", () => {
    window.location = "/logout";
})


// Navbar button to go to route "/"
document.querySelector("#btn-home").addEventListener("click", () => {
    console.log("hi there")
    window.location = "/";
})



/*
// Drag n drop div elements to attach a selected choice to a room/event
function onDragStart(event) {
    event.dataTransfer.setData('text/plain', event.target.id);
    event.currentTarget.style.backgroundColor = 'snow';
}

function onDragOver(event) {
    event.preventDefault();   
}

function onDrop(event) {
    const id = event.dataTransfer.getData('text')
    const draggableElement = document.getElementById(id);
    const dropZone = event.target;
    dropZone.appendChild(draggableElement);
    event.dataTransfer.clearData();
}
*/
