

$(document).ready(function() {
    // --------------------- Event Listeners ---------------------

    // Navbar button to log user out
    document.querySelector("#btn-logout").addEventListener("click", () => {
        window.location = "/logout";
    })

    // Triggers live update of choices being added to a room
    document.getElementById('form_add_choices').addEventListener('submit', searchAPI);




    // --------------------- Socket Related ---------------------
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
        // console.log(`%c ${JSON.stringify(data)}`, "background: black; color: pink")
        let choice_item = ""
        if (data.event_type == "fptp") {
            choice_item = choice_item + `<div class = "room_choice_items"> &emsp; <input type="radio" name="choice_id" value=${data.choice.choice_id}>&nbsp;`
        } else if (data.event_type == "random") {
            choice_item = choice_item + `<div class = "room_choice_items">`
        }

        if (data.choice.type != "custom") {
            choice_item = choice_item + `&nbsp;<a href="/details/${data.choice.choice_id}" class="choice_title" target="popup"
            onclick="window.open('/details/${data.choice.choice_id}', 'popup', 'width=1000, height=700'); return false;">${data.choice.title}</a>`
        } else {
            choice_item = choice_item + `&nbsp;<span class="choice_title">${data.choice.title}</span>`
        }

        choice_item = choice_item + `<button type="submit" class="btn btn-bg-dark" formaction = "/remove_choice" name="choice_id" value="${ data.choice.choice_id }"> Remove </button><br></div>`

        const event_choice_list = document.querySelector(".room_choices")
        event_choice_list.insertAdjacentHTML('beforeend', choice_item)

    });


    /*
    // Ensures other connected clients dont get re-routed if in item detail view
    if (window.location.href.indexOf('details') === -1) {
        window.location = `/room/${data.room_code}`
    }
    */


    // Display winning result for a room
    socket.on('show_winner', function(data) {
        window.location = `/room/${data.room_code}`
    })


    // Placeholder room refrsher
    socket.on('refresh_room', function(data) {
        window.location = `/room/${data.room_code}`
    })



    $('form#form_room_chat').submit(function(event){
//        socket.emit('chat', {data: $('#room_chat_input').val()});
        socket.emit('message', {data: $('#room_chat_input').val()});
        return false;
    });


    // testing disconnect even, remove later
    $('#btn_test').click(function(event) {
        socket.emit('message', {data: " has disconnected"});
    })




}); // closes Document.ready


// --------------------- Async Functions ---------------------

// Live update choices being added to an event/room
async function searchAPI(evt) {
    evt.preventDefault();
    console.log(JSON.stringify(evt))

    const formData = {
        event_id: document.querySelector('[name=event_id').value,
        room_code: document.querySelector('[name=form_room_code').value,
        create_choice: document.querySelector('[name=create_choice').value,
        choice_type: document.querySelector('[name=choice_type').value,
        choice_title: document.querySelector('[name=choice_title').value,
        art: document.querySelector('[name=art').value
    };

    const requestOptions = {
        method: "POST",
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(formData)
    }

    const response = await fetch('/add_choice', requestOptions)
    const apiData = await response.json()

    document.querySelector(".search_result_container").innerHTML = "";

    apiData.forEach( item =>
        $(".search_result_container").append(`<div class="search_result_item" id="${item.data[0]}" draggable="true"
        onDragStart="onDragStart(event)" onDragEnd="onDragEnd(event)" choice_title="${item.data[0]}" choice_type=${item.data[1]}
        event_id=${item.data[2]} room_code=${item.data[3]} create_choice="1" art=${item.data[4]}>${item.data[0]}</div>`)
)}



// Drag & drop API search results to attach it into room/event choices
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
        'create_choice': draggableElement.getAttribute('create_choice'),
        'art': draggableElement.getAttribute('art')
    }

    const requestOptions = {
        method: "POST",
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify(data)
    }

    event.dataTransfer.clearData();
    await fetch('/add_choice', requestOptions);
//    window.location = "/room/" + data['room_code'];

    /*
    const dropZone = event.target;
    dropZone.appendChild(draggableElement);
    event.dataTransfer.clearData();
    */
}

// --------------------- Button Click Functions ---------------------

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

// Button to populate SMS message field with specific room invite
function prep_sms(room_code) {
    message = `Join the room @ http://localhost:5000/room/${room_code}`
    document.getElementById("sms_message").value = message
}


// [room_create.html] > Displays info about the chosen voting method

function display_voting_method_info(event) {
    let anchor = document.getElementById("create_room_description");

    if (event.target.value == 'fptp') {
        const content = '<strong>Each person gets 1 vote. The candidate with the most vote at the end wins</strong> <br><br> \
        <iframe width="650" height="375" src="https://www.youtube.com/embed/s7tWHJfhiyo" title="YouTube video player" frameborder="0" \
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> \
        <br>(and why it is a bad system)'
        anchor.innerHTML = content;
        document.getElementById("donate").style.display="None";
    }
    else if (event.target.value == 'random') {
        const content = 'Once all options are entered, the room will be locked and a winning option will be randomly chosen <br><br> \
        <a href="https://en.wikipedia.org/wiki/Random_ballot">Random Ballot</a>'
        anchor.innerHTML = content;
        document.getElementById("donate").style.display="None";
    }
    else if (event.target.value == 'alternative') {
        const content = '<strong>Rank the choices in order of your preference. Does not force you into voting defensively</strong> <br><br> \
        <iframe width="650" height="375" src="https://www.youtube.com/embed/3Y3jE3B8HsE" title="YouTube video player" frameborder="0" \
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'

        anchor.innerHTML = content;
        document.getElementById("donate").style.display="block";
    }
}







