defmodule MusicBot.Commands do
  def command_list() do
    [
      %{
        name: "idea",
        description: "Add an idea to the idea pool",
        options: [
          %{
            # String
            type: 3,
            name: "idea",
            description: "The idea you're submitting",
            required: true
          }
        ]
      },
      %{
        name: "list",
        description: "List the idears"
      },
      %{
        name: "pick",
        description: "Pick an idear"
      },
      %{
        name: "bully",
        description: "Bully someone to pick a song for Music League",
        options: [
          %{
            # String
            type: 3,
            name: "name",
            description: "The name of the person to bully",
            required: true
          }
        ]
      },
      %{
        name: "ryansucks",
        description: "Show appreciation for Ryan"
      }
    ]
  end
end
