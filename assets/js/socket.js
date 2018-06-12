import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:lobby", {})

$(document).ready(function(){
  window.addEventListener("keypress", event => {
    if(event.keyCode === 13) {
      channel.push("event", {body: "Test click through channels"});
    }
  });

  channel.on("event", payload => {
    console.log(payload.body);
  });
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
