import {get_toolbar, build_text} from "./patterns"

export function update_page(payload) {
  var page_content = $("#lesson_page_content");

  // clear page
  page_content.empty();

  // build page content
  var titles = (payload.page_titles) ? payload.page_titles.split(";").filter(function(n){ return n != "" }) : "";
  var contents = (payload.page_contents) ? payload.page_contents.split(";").filter(function(n){ return n != "" }) : "";
  var answers = (payload.page_answers) ? payload.page_answers.split(";").filter(function(n){ return n != "" }) : "";

  var exercises = "";

  for(var i = 0; i < titles.length; i++) {
    var ex_title = `<div class="exercise-title"><span>${titles[i].slice(1)}</span></div>`;

    var ex_content = (contents[i]) ? `<div class="exercise-content">${contents[i].slice(1)}</div>` : "";

    exercises += `<div id="ex_${i+1}" class="exercise">${ex_title}${ex_content}</div>`;
  }

  // add new page content
  page_content.append(exercises);


  // htmlyze
  htmlyze();
}

export function get_next_ex_number() {
  var ex_id = 1;
  var ex_count = $("#page_titles").val().split(";").filter(function(n){ return n != "" }).length;

  return ex_count == 0 ? ex_id : ex_count + 1;
}

export function get_next_input_id_number() {
  var input_id = 1;
  var input_count = $(".fill-the-gap-input").length;

  return input_count == 0 ? input_id : input_count + 1;
}

export function save_exercise(ex_id) {
  // get current title
  var new_title = $(`#input_exercise_title_${ex_id}`).val();
  var new_content = "";

  //datalize from html
  if ($(".text-textarea")) {
    new_content = $(`#toolbar_text_textarea_${ex_id}`).html();

    // extract containers
    var ftg_containters = extract_ftg_container(new_content);
    console.log(ftg_containters);

    // extract inputs
    var ftg_inputs = ftg_containters.join().match(/<input([\s\S]*?)>/g);
    console.log(ftg_inputs);

    // make new input with attributes
    var new_inputs = [];
    for (var i = 0; i < ftg_inputs.length; i++) {
      var new_input = ftg_inputs[i];
      new_inputs.append(new_input);
    }

    // replace them in a string
    /*for (var i = 0; i < ftg_containters.length; i++) {
      new_content = new_content.replace(ftg_containters[i], new_inputs[i]);
    }*/
  }

  // search first chars of substrings
  if (id_exists_in_titles($("#page_titles").val(), ex_id)) {
    // update title
    $("#page_titles").val(function(i, text) {
      var title = get_title_with_id(text.split(';'), ex_id);
      return text.replace(title, `${ex_id}${new_title}`);
    });

    // update content
    $("#page_content").val(function(i, text) {
      var content_to_update = get_content_with_id(text.split(';'), ex_id);

      if (content_to_update) {
        // update content
        var content = get_content_with_id(text.split(';'), ex_id);
        return text.replace(`${content};`, `${ex_id}${new_content};`);
      } else {
        return `${text}${ex_id}${new_content};`;
      }
    });
  } else {
    // add new title
    $("#page_titles").val(function(i, text) {
      return `${text}${ex_id}${new_title};`;
    });

    //add new content
    $("#page_content").val(function(i, text) {
      return `${text}${ex_id}${new_content};`;
    });
  }

  var last_titles = $("#page_titles").val();
  var last_contents = $("#page_content").val();

  update_page_on_change(last_titles, last_contents, "");
}

export function remove_exercise(ex_id) {

  var last_titles = $("#page_titles").val();
  var last_contents = $("#page_content").val();

  var title_to_remove = get_title_with_id(last_titles.split(';'), ex_id);
  var content_to_remove = get_content_with_id(last_contents.split(';'), ex_id);

  if (title_to_remove) {
    //remove title
    var new_title = last_titles.replace(`${title_to_remove};`, '');
    $("#page_titles").val(new_title);

    //remove content
    var new_content = last_contents.replace(`${content_to_remove};`, '');
    $("#page_content").val(new_content);
  }
}

export function render_exercise_form(ex_id, titles, contents) {
  var remove_exercise_button = `
    <div class="right-align">
      <span class="waves-effect waves-red btn-flat remove-exercise-button" data-ex_id="${ex_id}">
        <i class="material-icons red-text text-lighten-3">close</i>
      </span>
    </div>`;

  // make title input
  var write_title = `
    <div class="input-field">
      <input value="${titles[ex_id-1].slice(1)}" id="input_exercise_title_${ex_id}" type="text" class="edit-field">
      <label class="active" for="input_exercise_title_${ex_id}">Exercise title</label>
    </div>`;
  var title_input = `<div class="title-input">${write_title}</div>`;

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

  // if type == text then build_text
  if (contents[ex_id-1]) {
    build_text(ex_id, contents[ex_id-1].slice(1));
  } else {
    console.log("Nothing to show");
  }
}


function id_exists_in_titles(titles, ex_id) {
  if (titles) {
    var titles_list = titles.split(';');
    for (var i = 0; i < titles_list.length; i++) {
      if (titles_list[i].charAt(0) == ex_id.toString()) return true;
    }
    return false;
  } else {
    return false;
  }
}

function get_title_with_id(titles, id) {
  for (var i = 0; i < titles.length; i++)
    if (titles[i].charAt(0) == id.toString()) return titles[i];
}

function get_content_with_id(contents, id) {
  for (var i = 0; i < contents.length; i++)
    if (contents[i].charAt(0) == id.toString()) return contents[i];
}

function update_page_on_change(page_titles, page_contents, page_answers) {
  var page_content = $("#lesson_page_content");

  // clear page
  page_content.empty();

  // build page content
  var titles = (page_titles) ? page_titles.split(";").filter(function(n){ return n != "" }) : "";
  var contents = (page_contents) ? page_contents.split(";").filter(function(n){ return n != "" }) : "";
  var answers = (page_answers) ? page_answers.split(";").filter(function(n){ return n != "" }) : "";

  var exercises = "";

  for(var i = 0; i < titles.length; i++) {
    var ex_title = `<div class="exercise-title"><span>${titles[i].slice(1)}</span></div>`;
    var ex_content = (contents[i]) ? `<div class="exercise-content">${contents[i].slice(1)}</div>` : "";

    exercises += `<div id="ex_${i+1}" class="exercise">${ex_title}${ex_content}</div>`;
  }

  // add new page content
  page_content.append(exercises);


  // htmlyze
  htmlyze();
}

function datalize(html) {
  return html;
}

function htmlyze() {
  $("div.exercise-content").find("ul").addClass("browser-default ulist");
  $("div.exercise-content").find("ol").addClass("olist");
  $("div.exercise-content").find("li").addClass("litem");
}

function extract_ftg_container(content) {
  var regexp = /<span id=\"fill_the_gap_[0-9]\"([\s\S]*?)><span([\s\S]*?)>([\s\S]*?)<\/span><input([\s\S]*?)><\/span>/g
  return content.match(regexp);
}
