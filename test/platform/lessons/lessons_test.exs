defmodule Platform.LessonsTest do
  use Platform.DataCase

  alias Platform.Lessons

  describe "lessons" do
    alias Platform.Lessons.Lesson

    @valid_attrs %{grammar: "some grammar", img_uri: "some img_uri", order: 42, tags: "some tags", title: "some title", words: "some words"}
    @update_attrs %{grammar: "some updated grammar", img_uri: "some updated img_uri", order: 43, tags: "some updated tags", title: "some updated title", words: "some updated words"}
    @invalid_attrs %{grammar: nil, img_uri: nil, order: nil, tags: nil, title: nil, words: nil}

    def lesson_fixture(attrs \\ %{}) do
      {:ok, lesson} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lessons.create_lesson()

      lesson
    end

    test "list_lessons/0 returns all lessons" do
      lesson = lesson_fixture()
      assert Lessons.list_lessons() == [lesson]
    end

    test "get_lesson!/1 returns the lesson with given id" do
      lesson = lesson_fixture()
      assert Lessons.get_lesson!(lesson.id) == lesson
    end

    test "create_lesson/1 with valid data creates a lesson" do
      assert {:ok, %Lesson{} = lesson} = Lessons.create_lesson(@valid_attrs)
      assert lesson.grammar == "some grammar"
      assert lesson.img_uri == "some img_uri"
      assert lesson.order == 42
      assert lesson.tags == "some tags"
      assert lesson.title == "some title"
      assert lesson.words == "some words"
    end

    test "create_lesson/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lessons.create_lesson(@invalid_attrs)
    end

    test "update_lesson/2 with valid data updates the lesson" do
      lesson = lesson_fixture()
      assert {:ok, lesson} = Lessons.update_lesson(lesson, @update_attrs)
      assert %Lesson{} = lesson
      assert lesson.grammar == "some updated grammar"
      assert lesson.img_uri == "some updated img_uri"
      assert lesson.order == 43
      assert lesson.tags == "some updated tags"
      assert lesson.title == "some updated title"
      assert lesson.words == "some updated words"
    end

    test "update_lesson/2 with invalid data returns error changeset" do
      lesson = lesson_fixture()
      assert {:error, %Ecto.Changeset{}} = Lessons.update_lesson(lesson, @invalid_attrs)
      assert lesson == Lessons.get_lesson!(lesson.id)
    end

    test "delete_lesson/1 deletes the lesson" do
      lesson = lesson_fixture()
      assert {:ok, %Lesson{}} = Lessons.delete_lesson(lesson)
      assert_raise Ecto.NoResultsError, fn -> Lessons.get_lesson!(lesson.id) end
    end

    test "change_lesson/1 returns a lesson changeset" do
      lesson = lesson_fixture()
      assert %Ecto.Changeset{} = Lessons.change_lesson(lesson)
    end
  end
end
