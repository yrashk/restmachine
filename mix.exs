defmodule Restmachine.Mixfile do
  use Mix.Project

  def project do
    [ app: :restmachine,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:cage, :eflow],
     included_applications: [:cowboy]]
  end
  defp deps do
    [
      { :cage, %r(.*), github: "yrashk/cage" },
      { :eflow, %r(.*), github: "yrashk/eflow" },
      { :cowboy, %r(.*), github: "extend/cowboy" },
      { :ranch, %r(.*), github: "extend/ranch" },
    ]
  end
end
