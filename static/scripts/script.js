

// Chat function
$(document).ready(function() {
    var socket = io();
    
    socket.on('connect', function() {
        socket.emit('join', {});
    });

    socket.on('status', function(data) {
        $('#room_chat_box').append('<br>' + $('<div/>').text(data.msg).html());
    })

    
    socket.on('my_response', function(msg, cb) {
//        alert("message : " + JSON.stringify(msg))
        $('#room_chat_box').append('<br>' + $('<div/>').text(msg.username + ': ' + msg.data).html());
        document.getElementById('room_chat_box').scrollIntoView({ behavior: 'smooth', block: 'end' });
        document.getElementById('room_chat_input').value = '';

        if (cb)
            cb();
    });
        

    $('form#form_room_chat').submit(function(event){
//        socket.emit('chat', {data: $('#room_chat_input').val()});
        socket.emit('message', {data: $('#room_chat_input').val()});
        return false;
    });

    $('form#emit').submit(function(event) {
        socket.emit('chat', {data: $('#emit_data').val()});
        return false;
    });
    $('form#broadcast').submit(function(event) {
        socket.emit('my_broadcast_event', {data: $('#broadcast_data').val()});
        return false;
    });
    $('form#disconnect').submit(function(event) {
        socket.emit('message');
        return false;
    });

    $('#btn_test').click(function(event) {
        socket.emit('message', {data: " has disconnected"});
    })
});



// Navbar button to go to route "/"
document.querySelector("#btn-home").addEventListener("click", () => {
    window.location = "/";
})


// Navbar button to create a room
document.querySelector("#btn-create-room").addEventListener("click", () => {
    window.location = "/create_room";
})

// Navbar button to view user profile
document.querySelector("#btn-view-user-profile").addEventListener("click", () => {
    window.location = "/view_user_profile";
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

