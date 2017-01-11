defmodule Sesamex.Helpers do
  import Loki.File
  import Loki.Shell
  import Loki.Directory


  @moduledoc """
  Reusable helpers for sesamex.
  """


  @doc """
  Return current time timestamp string.
  """
  @spec timestamp() :: String.t
  def timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end


  @doc """
  Create directory or do nothing if exists.
  """
  @spec create_directory_unless_exist(Path.t) :: none()
  def create_directory_unless_exist(path) do
    if exists_file? path do
      say_exists(path)
    else
      create_directory(path)
    end
  end


  @doc """
  Create file from string in given path.
  """
  @spec create_file_from(String.t, Path.t) :: none()
  def create_file_from(template, path) do
    if exists_file? path do
      if identical_file?(path, template) do
        say_identical(path)
      else
        say_exists(path)
        if yes?(" Do you want to force create file? [Yn] ") do
          create_file_force(path, template)
        else
          say_skip(path)
        end
      end
    else
      create_file(path, template)
    end
  end


  @spec pad(Number.t) :: String.t
  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
