import {get_next_input_id_number} from "./helpers"

export function get_toolbar(ex_id) {

  var text = `
    <span id="text_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-text">
      <i class="material-icons">short_text</i>text
    </span>`;

  var matching = `
    <span id="matching_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-matching">
      <i class="material-icons">compare_arrows</i>matching
    </span>`;

  var reorder = `
    <span id="reorder_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-reorder">
      <i class="material-icons">reorder</i>reorder
    </span>`;

  var dialogues = `
    <span id="dialogues_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-dialogues">
      <i class="material-icons">people_outline</i>dialogue
    </span>`;

  var multiple_choice = `
    <span id="multiple_choice_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-multiple-choice">
      <i class="material-icons">radio_button_checked</i>multiple choice
    </span>`;

  var true_false = `
    <span id="true_false_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-true-false">
      <i class="material-icons">check</i>true/false
    </span>`;

  var flip_the_card = `
    <span id="flip_the_card_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-flip-the-card">
      <i class="material-icons">flip</i>flip the card
    </span>`;

  var drag_word_to_picture = `
    <span id="drag_word_to_picture_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-drag-word-to-picture">
      <i class="material-icons">art_track</i>drag word to picture
    </span>`;

  var correct_option = `
    <span id="correct_option_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-correct-option">
      <i class="material-icons">done_all</i>correct option
    </span>`;

  var audio = `
    <span id="audio_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-audio">
      <i class="material-icons">audiotrack</i>audio
    </span>`;

  var video = `
    <span id="video_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-video">
      <i class="material-icons">ondemand_video</i>video
    </span>`;

  var recording = `
    <span id="recording_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-recording">
      <i class="material-icons">fiber_manual_record</i>recording
    </span>`;

  var essay = `
    <span id="essey_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-essey">
      <i class="material-icons">format_align_left</i>essay
    </span>`;

  var translation = `
    <span id="translation_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-translation">
      <i class="material-icons">translate</i>translation
    </span>`;

  var grammar = `
    <span id="grammar_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-grammar">
      <i class="material-icons">web</i>grammar
    </span>`;

  var game = `
    <span id="game_${ex_id}" class="waves-effect btn-flat centered-img-button toolbar-game">
      <i class="material-icons">videogame_asset</i>game
    </span>`;

  return `${text}${essay}${translation}${grammar}${dialogues}
          ${matching}${reorder}${multiple_choice}${true_false}
          ${flip_the_card}${drag_word_to_picture}${correct_option}
          ${audio}${video}${recording}${game}`;
}


export function build_text(ex_id, content, answers_batched) {
  // remove toolbar with fade in
  $(`#exercise_toolbar_${ex_id}`).remove();

  // insert textarea with fade out
  var b = `
    <span class="waves-effect btn-flat centered-img-button" data-ex_id="${ex_id}" data-command='bold'><b>b</b></span>`;
  var em = `
    <span class="waves-effect btn-flat centered-img-button" data-ex_id="${ex_id}" data-command='italic'><em>i</em></span>`;
  var un = `
    <span class="waves-effect btn-flat centered-img-button" data-ex_id="${ex_id}" data-command='underline'><u>u</u></span>`;
  var ordered_list = `
    <span class="waves-effect btn-flat centered-img-button" data-ex_id="${ex_id}" data-command='insertOrderedList'>
      <i class="material-icons">format_list_numbered</i></span>`;
  var unordered_list = `
    <span class="waves-effect btn-flat centered-img-button" data-ex_id="${ex_id}" data-command='insertUnorderedList'>
      <i class="material-icons">format_list_bulleted</i></span>`;
  var fill_the_gap = `
    <span class="waves-effect btn-flat centered-img-button" data-ex_id="${ex_id}" data-command='insertHTML'>
      <i class="material-icons">create</i>fill the gap</span>`;

  var remove = `
    <span class="waves-effect btn-flat remove-pattern-button" data-ex_id="${ex_id}">
      <i class="material-icons">close</i>
    </span>`;

  var panel = `<div class="toolbar-text-panel"><span class="">${b}${em}${un}${ordered_list}${unordered_list}${fill_the_gap}</span>${remove}</div>`;
  var textarea = `<div id="toolbar_text_textarea_${ex_id}" class="toolbar-text-textarea textarea-resizeable" contenteditable>${content}</div>`;

  var combined_html = `<div class="text-textarea" data-ex_id="${ex_id}">${panel}${textarea}</div>`;

  $(`#exercise_content_hidden_${ex_id}`).before(combined_html);

  // Add answers to textarea
  var answers = answers_batched.split(",");
  answers.sort(function(a, b) {
    return parseInt(a.charAt(0)) - parseInt(b.charAt(0));
  });

  for (var i = 0; i < answers.length; i++) {
    answers[i] = answers[i].trim();
    var input_id = answers[i].charAt(0);

    var answer_html = `<input id="fill_the_gap_answer_input_${input_id}" type="text" class="browser-default fill-the-gap-answer-input" value="${answers[i].substring(1)}">`;
    $(`#fill_the_gap_input_${input_id}`).after(answer_html);
  }


  // resize textarea
  $(`#toolbar_text_textarea_${ex_id}`).each(function () {
    this.setAttribute('style', 'height:' + (this.scrollHeight) + 'px;overflow-y:hidden;overflow-x:hidden;');
  }).on('input', function () {
    this.style.height = 'auto';
    this.style.height = (this.scrollHeight) + 'px';
  });

  // remove textarea
  $(`.remove-pattern-button[data-ex_id=${ex_id}]`).click(function() {
    //remove_pattern(ex_id);
    $(`.text-textarea[data-ex_id=${ex_id}]`).remove();

    var exercise_toolbar = `<div id="exercise_toolbar_${ex_id}" class="exercise-toolbar">${get_toolbar(ex_id)}</div>`;
    $(`#exercise_content_hidden_${ex_id}`).before(exercise_toolbar);
  });

  // text-pattern toolbar buttons click
  $(`.centered-img-button[data-ex_id=${ex_id}]`).click(function(e) {
    var command = $(this).data('command');

    if (command == 'insertHTML') {
      var input_id = get_next_input_id_number();

      var fill_the_gap_placeholder = `<span id="fill_the_gap_placeholder_${input_id}" class="fill-the-gap-placeholder"></span>`;
      var fill_the_gap_input = `<input id="fill_the_gap_input_${input_id}" type="text" class="browser-default fill-the-gap-input" autocomplete="off">`;
      var fill_the_gap_answer = `<input id="fill_the_gap_answer_input_${input_id}" type="text" class="browser-default fill-the-gap-answer-input">`;
      var fill_the_gap_html = `<span></span><span id="fill_the_gap_${input_id}" class="fill-the-gap" contenteditable="false">${fill_the_gap_placeholder}${fill_the_gap_input}${fill_the_gap_answer}</span><span></span>`;

      document.execCommand(command, false, fill_the_gap_html);

    } else document.execCommand(command, false, null);
  });
}
