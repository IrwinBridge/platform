import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

let channel = socket.channel("room:lobby", {});


/**************************** EVENTS CODE ******************************/
import {update_page} from "./helpers";


$("#page_name").ready(function() {

  // For show.html inside lessons
  if($("#page_name").text() == "showlesson") {
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
        update_page(payload);
      });

    // Lesson page loading
    $("#lesson_page_content").ready(function() {
      channel.push("load_lesson_page_event", {page_id: $("#lesson_page_content").data("page_id")});
    });
    channel.on("load_lesson_page_event", payload => {
      update_page(payload);
    });
  }

  // For show.html inside lessons
  if($("#page_name").text() == "editpage") {
    $("#lesson_page_content").ready(function() {
      channel.push("load_lesson_page_event", {page_id: $("#lesson_page_content").data("page_id")});
    });
    channel.on("load_lesson_page_event", payload => {
      update_page(payload);
    });
  }
});



channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
