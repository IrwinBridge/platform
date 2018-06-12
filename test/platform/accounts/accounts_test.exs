defmodule Platform.AccountsTest do
  use Platform.DataCase

  alias Platform.Accounts

  describe "users" do
    alias Platform.Accounts.User

    @valid_attrs %{about: "some about", avatar_url: "some avatar_url", is_admin: true, is_moderator: true, lessons: %{}, lessons_balance: 42, name: "some name", role: "some role", surname: "some surname", username: "some username"}
    @update_attrs %{about: "some updated about", avatar_url: "some updated avatar_url", is_admin: false, is_moderator: false, lessons: %{}, lessons_balance: 43, name: "some updated name", role: "some updated role", surname: "some updated surname", username: "some updated username"}
    @invalid_attrs %{about: nil, avatar_url: nil, is_admin: nil, is_moderator: nil, lessons: nil, lessons_balance: nil, name: nil, role: nil, surname: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.about == "some about"
      assert user.avatar_url == "some avatar_url"
      assert user.is_admin == true
      assert user.is_moderator == true
      assert user.lessons == %{}
      assert user.lessons_balance == 42
      assert user.name == "some name"
      assert user.role == "some role"
      assert user.surname == "some surname"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.about == "some updated about"
      assert user.avatar_url == "some updated avatar_url"
      assert user.is_admin == false
      assert user.is_moderator == false
      assert user.lessons == %{}
      assert user.lessons_balance == 43
      assert user.name == "some updated name"
      assert user.role == "some updated role"
      assert user.surname == "some updated surname"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "credentials" do
    alias Platform.Accounts.Credential

    @valid_attrs %{email: "some email", password: "some password", password_confirmation: "some password_confirmation", password_hash: "some password_hash"}
    @update_attrs %{email: "some updated email", password: "some updated password", password_confirmation: "some updated password_confirmation", password_hash: "some updated password_hash"}
    @invalid_attrs %{email: nil, password: nil, password_confirmation: nil, password_hash: nil}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_credential()

      credential
    end

    test "list_credentials/0 returns all credentials" do
      credential = credential_fixture()
      assert Accounts.list_credentials() == [credential]
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = credential_fixture()
      assert Accounts.get_credential!(credential.id) == credential
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Accounts.create_credential(@valid_attrs)
      assert credential.email == "some email"
      assert credential.password == "some password"
      assert credential.password_confirmation == "some password_confirmation"
      assert credential.password_hash == "some password_hash"
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()
      assert {:ok, credential} = Accounts.update_credential(credential, @update_attrs)
      assert %Credential{} = credential
      assert credential.email == "some updated email"
      assert credential.password == "some updated password"
      assert credential.password_confirmation == "some updated password_confirmation"
      assert credential.password_hash == "some updated password_hash"
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
      assert credential == Accounts.get_credential!(credential.id)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = credential_fixture()
      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end
end
