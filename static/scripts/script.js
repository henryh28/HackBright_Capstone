

// Navbar button to go to route "/"
document.querySelector("#btn-home").addEventListener("click", () => {
    window.location = "/";
})


// Navbar button to create a room
document.querySelector("#btn-create-room").addEventListener("click", () => {
    window.location = "/create_room";
})


// Navbar button to log user out
document.querySelector("#btn-logout").addEventListener("click", () => {
    window.location = "/logout";
})



// Drag n drop div elements to attach a selected choice to a room/event
function onDragStart(event) {
    event.dataTransfer.setData('text/plain', event.target.id);
    event.currentTarget.style.backgroundColor = 'mistyrose';
}

function onDragOver(event) {
    event.preventDefault();   
}

async function onDrop(event) {
    const id = event.dataTransfer.getData('text')
    const draggableElement = document.getElementById(id);

    const data = {
        'choice_title': draggableElement.id,
        'choice_type': draggableElement.getAttribute('choice_type'),
        'event_id': draggableElement.getAttribute('event_id'),
        'room_code': draggableElement.getAttribute('room_code'),
        'create_choice': draggableElement.getAttribute('create_choice')
    }

    const requestOptions = {
        method: "POST",
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(data)
    }

    event.dataTransfer.clearData();
    await fetch('/add_choice', requestOptions);
    window.location = "room/" + data['room_code'];
    
    /*
    const dropZone = event.target;
    dropZone.appendChild(draggableElement);
    event.dataTransfer.clearData();
    */
}

