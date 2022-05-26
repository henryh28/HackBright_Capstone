

async function searchAPI(evt) {
    evt.preventDefault();

    const formData = {
        event_id: document.querySelector('[name=event_id').value,
        room_code: document.querySelector('[name=form_room_code').value,
        create_choice: document.querySelector('[name=create_choice').value,
        choice_type: document.querySelector('[name=choice_type').value,
        choice_title: document.querySelector('[name=choice_title').value        
    };

    const requestOptions =  {
        method: "POST",
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(formData)
    }

    const response = await fetch('/add_choice', requestOptions)
    const apiData = await response.json()

    console.log(apiData)
    document.querySelector(".search_result_container").innerHTML = "";


    apiData.forEach( item => 
        $(".search_result_container").append(`<div class="search_result_item" id="${item.data[0]}" draggable="true" 
        onDragStart="onDragStart(event)" onDragEnd="onDragEnd(event)" choice_title="${item.data[0]}" choice_type=${item.data[1]} 
        event_id=${item.data[2]} room_code=${item.data[3]} create_choice="1">${item.data[0]} </div>`)
    )
}

document.getElementById('form_add_choices').addEventListener('submit', searchAPI);



// Toggle Menu
$("#menu-toggle").click(function (e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
});


// todo: extract out socket related script to
// Real time chat & Room choice updates
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
        const chat_text = '<br >' + `<span style="color: ${msg.chat_color}; background-color: ${msg.chat_bg_color}">` + '<strong>' + msg.username + '</strong>' + ' : ' + msg.data + '</span>'

        $('#room_chat_box').append(chat_text);
        document.getElementById('room_chat_box').scrollIntoView({ behavior: 'smooth', block: 'end' });
        document.getElementById('room_chat_input').value = '';

        if (cb)
            cb();
    });

    // Real time update of current room choices for all connected clients
    socket.on('update_choices', function(data) {

        // Ensures other connected clients dont get re-routed if in item detail view
        if (window.location.href.indexOf('details') === -1) {
            window.location = `/room/${data.room_code}`
        } 
    })

        

    $('form#form_room_chat').submit(function(event){
//        socket.emit('chat', {data: $('#room_chat_input').val()});
        socket.emit('message', {data: $('#room_chat_input').val()});
        return false;
    });

    $('#btn_test').click(function(event) {
        socket.emit('message', {data: " has disconnected"});
    })


/*
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
*/
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



// Updates user's chat color preference
function change_chat_color(event) {
    url_loc = `/set_chat_color?color=${event.substring(1)}`    
    window.location = url_loc
}

// Updates user's chat bg color preference
function change_chat_bg_color(event) {
    url_loc = `/set_chat_bg_color?color=${event.substring(1)}`    
    window.location = url_loc
}


// Navbar button to view user profile
function view_user_profile(event) {
    window.location = "/view_user_profile";
}

// Navbar button to log user out
function user_logout(event) {
    window.location = "/logout";
}



// Drag n drop div elements to attach a selected choice to a room/event
function onDragStart(event) {
    event.dataTransfer.setData('text/plain', event.target.id);
    event.currentTarget.style.backgroundColor = 'lavender';
}

function onDragEnd(event) {
    event.currentTarget.style.backgroundColor = 'inherit';
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
    window.location = "/room/" + data['room_code'];
    
    /*
    const dropZone = event.target;
    dropZone.appendChild(draggableElement);
    event.dataTransfer.clearData();
    */
}

