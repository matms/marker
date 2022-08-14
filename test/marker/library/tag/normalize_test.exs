defmodule Marker.Library.Tag.NormalizeTest do
  @moduledoc false

  use ExUnit.Case
  import Marker.Library.Tag.Normalize

  describe "Normalize.normalized/1" do
    test "Normalizing a tag trims whitespace" do
      assert normalized(" abc ") == "abc"
    end

    test "Normalizing a tag makes it entirely lower case" do
      assert normalized("AbCd") == "abcd"
    end

    test "Normalizing a tag removes inner whitespace, underline, or dashes" do
      assert normalized("example-tag name_here") == "exampletagnamehere"
    end
  end
end
