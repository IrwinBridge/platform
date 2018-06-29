import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:lobby", {})

/**************************** EVENTS CODE ******************************/
$(document).ready(function(){

  $(".delete_page_button").click(function() {
    channel.push("delete_page_event", {page_id: $(this).data("pageid")});
  });
  channel.on("delete_page_event", payload => {
    location.reload();
  });

  $(".edit_page_button").click(function() {
    channel.push("edit_page_event", {page_id: $(this).data("pageid")});
  });
  channel.on("edit_page_event", payload => {
    window.location.href = `/lessons/edit_page/${payload.page_id}`;
  });

  $(".page-item").click(function() {
    channel.push("click_select_page_event", {page_id: $(this).data("page_id")});
    $(".page-item").removeClass("active");
    $(this).addClass("active");
  });
  channel.on("click_select_page_event", payload => {
    console.log(payload.page_id);
  });

});


channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
