import "phoenix_html"

import socket from "./socket"
import {get_next_ex_number, save_exercise, remove_exercise,
        render_exercise_form} from "./helpers"
import {get_toolbar, build_text, build_matching} from "./patterns"

require("materialize-css")


M.AutoInit();

M.Collapsible.init($(".collapsible.expandable"), {accordion: false});


$(document).ready(function() {
  // Hide submit button
  $("#logout").hide();
  $("#logout").parent().submit();

  // Show first page selected
  $("#page_name:contains('showlesson')").ready(function() {
    var selected_page_id = $("#lesson_page_content").data("page_id");
    $(`.page-item[data-page_id="${selected_page_id}"`).addClass("active");
  });


  // Edit page
  if($("#page_name").text() == "editpage") {

    $("#add_exercise_button").click(function() {
      var ex_id = get_next_ex_number();

      // make title input
      var write_title = `
        <div class="input-field">
          <input id="input_exercise_title_${ex_id}" type="text" class="edit-field">
          <label for="input_exercise_title_${ex_id}">Exercise title</label>
        </div>`;
      var title_input = `<div class="title-input">${write_title}</div>`;


      // prepend title input and exercises toolbar before button
      var remove_exercise_button = `
        <div class="right-align">
          <span class="waves-effect waves-red btn-flat remove-exercise-button" data-ex_id="${ex_id}">
            <i class="material-icons red-text text-lighten-3">close</i>
          </span>
        </div>`;


      var exercise_toolbar = `<div id="exercise_toolbar_${ex_id}" class="exercise-toolbar">${get_toolbar(ex_id)}</div>`;
      var exercise_content_hidden = `<div id="exercise_content_hidden_${ex_id}" hidden></div>`;

      var save_exercise_button = `<div class="right-align"><span class="waves-effect btn-flat save-exercise-button" data-ex_id="${ex_id}">save exercise</span></div>`;

      var compiled_html = `<div id="make_ex_${ex_id}" class="make-exercise-holder" data-ex_id="${ex_id}">
                            ${remove_exercise_button}
                            ${title_input}
                            ${exercise_toolbar}
                            ${exercise_content_hidden}
                            ${save_exercise_button}
                          </div>`;

      $("#add_exercise_button").before(compiled_html);
    });

    $("#make_the_page").on("click", ".remove-exercise-button", function() {
      var ex_id = this.dataset.ex_id;
      remove_exercise(ex_id);
      $(`.make-exercise-holder[data-ex_id=${ex_id}]`).remove();
    });

    $("#make_the_page").on("click", ".save-exercise-button", function() {
      var ex_id = this.dataset.ex_id;
      save_exercise(ex_id);
    });

    $("#lesson_page_content").ready(function() {
      // Get data from hidden div
      var titles = $("#page_titles").val().split(";").filter(function(n){ return n != "" });
      var contents = $("#page_content").val().split(";").filter(function(n){ return n != "" });
      var answers = $("#page_answers").val().split(";").filter(function(n){ return n != ""});

      // Treat it
      if (titles.length) {
        var ex_num = titles.length;

        // Render it
        for (var i = 1; i <= ex_num; i++) {
          render_exercise_form(i, titles, contents, answers);

          // Update values
          $(`#input_exercise_title_${i}`).ready(function() {
            $(this).val(titles[i-1]);
          });
        }
      }
    });


    // PATTERN BUTTONS
    $("#make_the_page").on("click", ".toolbar-text", function() {
      var id = this.getAttribute('id');
      var ex_id = id.substr(id.length - 1);

      build_text(ex_id, "", "");
    });

    $("#make_the_page").on("click", ".toolbar-matching", function() {
      var id = this.getAttribute('id');
      var ex_id = id.substr(id.length - 1);

      build_matching(ex_id, "");
    });
  }

  // Resizeable fill the gap
  $("main[role=main]").on('propertychange input', ".fill-the-gap-input-converted", function (e) {
    var $this = $(`#${this.id}`);
    var $ftg_placeholder = $this.parent().find(".fill-the-gap-placeholder");

    var valueChanged = false;

    if (e.type=='propertychange') {
      valueChanged = e.originalEvent.propertyName=='value';
    } else {
      valueChanged = true;
    }

    if (valueChanged) {
      var c = String.fromCharCode(e.keyCode | e.charCode);
      resizeInputToFitContent.call($this, $ftg_placeholder, $this.val() + c);
    }
  });

  // Answer checking
  $("main[role=main]").on('keydown', ".fill-the-gap-input-converted", function (e) {
    if (e.which == 13) {
      var $this = $(`#${this.id}`);
      var answer = $this.data("answer");
      var container = $this.parent();
      var parent_id = $this.parent().attr("id");

      if ($this.val().toLowerCase() == answer.toLowerCase()) {
        //console.log("Right!");
        var answer_html = `<span id="${parent_id}" class="fill-the-gap-answer" hidden>${answer}</span>`;

        container.fadeOut(400, function(){
          container.hide();
          container.replaceWith(answer_html);
          $(`#${parent_id}`).fadeIn(500);
        });
      } else {
        //console.log("Wrong!");
        $this.css("border-color", "#ff5252");
      }
    }
  });

  // Answer writing in edit mode
  $("main[role=main]").on('input', ".fill-the-gap-answer-input", function (e) {
    var $this = $(`#${this.id}`);

    $this.attr("value", $this.val());
  });

  // Predefined value writing in edit mode
  $("main[role=main]").on('input', ".fill-the-gap-input", function (e) {
    var $this = $(`#${this.id}`);

    $this.attr("value", $this.val());
  });

});


function resizeInputToFitContent($placeholder, text) {
  var $this = $(this);
  $placeholder.text(text);
  var $inputSize = $placeholder.width();
  $this.css("width", $inputSize);
}
