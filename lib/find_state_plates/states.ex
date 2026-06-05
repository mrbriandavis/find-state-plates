defmodule FindStatePlates.States do
  @states [
    %{
      code: "AL",
      name: "Alabama",
      row: 5,
      col: 9,
      trivia: "Alabama introduced the first 911 emergency call in 1968."
    },
    %{
      code: "AK",
      name: "Alaska",
      row: 6,
      col: 0,
      trivia: "Alaska has more coastline than the rest of the United States combined."
    },
    %{
      code: "AZ",
      name: "Arizona",
      row: 3,
      col: 3,
      trivia: "Arizona is home to the Grand Canyon, one of the world’s great natural landmarks."
    },
    %{
      code: "AR",
      name: "Arkansas",
      row: 4,
      col: 7,
      trivia: "Arkansas contains the only public diamond mine in North America."
    },
    %{
      code: "CA",
      name: "California",
      row: 2,
      col: 2,
      trivia: "California’s state economy is larger than that of many countries."
    },
    %{
      code: "CO",
      name: "Colorado",
      row: 2,
      col: 5,
      trivia: "Colorado is the only state entirely above 1,000 meters in elevation."
    },
    %{
      code: "CT",
      name: "Connecticut",
      row: 2,
      col: 13,
      trivia: "Connecticut is nicknamed the Constitution State."
    },
    %{
      code: "DE",
      name: "Delaware",
      row: 3,
      col: 13,
      trivia: "Delaware was the first state to ratify the U.S. Constitution."
    },
    %{
      code: "FL",
      name: "Florida",
      row: 6,
      col: 11,
      trivia: "Florida is the only state that borders both the Atlantic Ocean and the Gulf of Mexico."
    },
    %{
      code: "GA",
      name: "Georgia",
      row: 5,
      col: 10,
      trivia: "Georgia is known as the Peach State, even though South Carolina grows more peaches."
    },
    %{
      code: "HI",
      name: "Hawaii",
      row: 7,
      col: 1,
      trivia: "Hawaii is the only U.S. state made entirely of islands."
    },
    %{
      code: "ID",
      name: "Idaho",
      row: 1,
      col: 3,
      trivia: "Idaho produces about a third of the potatoes grown in the United States."
    },
    %{
      code: "IL",
      name: "Illinois",
      row: 2,
      col: 8,
      trivia: "Illinois is home to the Willis Tower and a long stretch of historic Route 66."
    },
    %{
      code: "IN",
      name: "Indiana",
      row: 2,
      col: 9,
      trivia: "Indiana hosts the world-famous Indianapolis 500 every year."
    },
    %{
      code: "IA",
      name: "Iowa",
      row: 2,
      col: 7,
      trivia: "Iowa is the nation’s top producer of corn."
    },
    %{
      code: "KS",
      name: "Kansas",
      row: 3,
      col: 6,
      trivia: "Kansas sits almost exactly at the geographic center of the contiguous United States."
    },
    %{
      code: "KY",
      name: "Kentucky",
      row: 3,
      col: 9,
      trivia: "Kentucky is home to Mammoth Cave, the world’s longest known cave system."
    },
    %{
      code: "LA",
      name: "Louisiana",
      row: 5,
      col: 7,
      trivia: "Louisiana’s legal system is based in part on civil law rather than English common law."
    },
    %{
      code: "ME",
      name: "Maine",
      row: 0,
      col: 15,
      trivia: "Maine is the only U.S. state with a one-syllable name."
    },
    %{
      code: "MD",
      name: "Maryland",
      row: 3,
      col: 12,
      trivia: "Maryland’s state flag is based on the Calvert and Crossland family coats of arms."
    },
    %{
      code: "MA",
      name: "Massachusetts",
      row: 1,
      col: 14,
      trivia: "Massachusetts is where the American Revolution began in earnest."
    },
    %{
      code: "MI",
      name: "Michigan",
      row: 1,
      col: 9,
      trivia: "Michigan is the only state split into two peninsulas."
    },
    %{
      code: "MN",
      name: "Minnesota",
      row: 0,
      col: 7,
      trivia: "Minnesota is known as the Land of 10,000 Lakes."
    },
    %{
      code: "MS",
      name: "Mississippi",
      row: 5,
      col: 8,
      trivia: "The Mississippi River forms much of Mississippi’s western border."
    },
    %{
      code: "MO",
      name: "Missouri",
      row: 3,
      col: 7,
      trivia: "Missouri’s Gateway Arch is the tallest national monument in the U.S."
    },
    %{
      code: "MT",
      name: "Montana",
      row: 0,
      col: 4,
      trivia: "Montana has more cattle than people."
    },
    %{
      code: "NE",
      name: "Nebraska",
      row: 2,
      col: 6,
      trivia: "Nebraska’s state capitol is one of the tallest in the country."
    },
    %{
      code: "NV",
      name: "Nevada",
      row: 2,
      col: 3,
      trivia: "Nevada is the driest state in the nation."
    },
    %{
      code: "NH",
      name: "New Hampshire",
      row: 0,
      col: 14,
      trivia: "New Hampshire’s motto is “Live Free or Die.”"
    },
    %{
      code: "NJ",
      name: "New Jersey",
      row: 2,
      col: 12,
      trivia: "New Jersey has more diners than any other state."
    },
    %{
      code: "NM",
      name: "New Mexico",
      row: 3,
      col: 4,
      trivia: "New Mexico’s official state question is “Red or green?” referring to chile."
    },
    %{
      code: "NY",
      name: "New York",
      row: 1,
      col: 12,
      trivia: "New York’s Adirondack Park is larger than Yellowstone, Everglades, Glacier, and Grand Canyon national parks combined."
    },
    %{
      code: "NC",
      name: "North Carolina",
      row: 4,
      col: 11,
      trivia: "North Carolina is recognized as the birthplace of powered flight."
    },
    %{
      code: "ND",
      name: "North Dakota",
      row: 0,
      col: 6,
      trivia: "North Dakota grows more sunflowers than any other state."
    },
    %{
      code: "OH",
      name: "Ohio",
      row: 2,
      col: 10,
      trivia: "Ohio is the birthplace of seven U.S. presidents."
    },
    %{
      code: "OK",
      name: "Oklahoma",
      row: 4,
      col: 6,
      trivia: "Oklahoma has the nation’s largest Native American population percentage-wise."
    },
    %{
      code: "OR",
      name: "Oregon",
      row: 1,
      col: 2,
      trivia: "Oregon is home to Crater Lake, the deepest lake in the United States."
    },
    %{
      code: "PA",
      name: "Pennsylvania",
      row: 2,
      col: 11,
      trivia: "Pennsylvania’s Liberty Bell is one of the country’s most recognized historic symbols."
    },
    %{
      code: "RI",
      name: "Rhode Island",
      row: 2,
      col: 14,
      trivia: "Rhode Island is the smallest state by area."
    },
    %{
      code: "SC",
      name: "South Carolina",
      row: 5,
      col: 11,
      trivia: "South Carolina has more than 180 miles of coastline."
    },
    %{
      code: "SD",
      name: "South Dakota",
      row: 1,
      col: 6,
      trivia: "South Dakota’s Mount Rushmore features four U.S. presidents."
    },
    %{
      code: "TN",
      name: "Tennessee",
      row: 4,
      col: 9,
      trivia: "Tennessee is home to the Great Smoky Mountains National Park, the most visited U.S. national park."
    },
    %{
      code: "TX",
      name: "Texas",
      row: 5,
      col: 5,
      trivia: "Texas is the second-largest state by both area and population."
    },
    %{
      code: "UT",
      name: "Utah",
      row: 2,
      col: 4,
      trivia: "Utah contains five national parks, often called the Mighty 5."
    },
    %{
      code: "VT",
      name: "Vermont",
      row: 0,
      col: 13,
      trivia: "Vermont is the nation’s largest producer of maple syrup."
    },
    %{
      code: "VA",
      name: "Virginia",
      row: 3,
      col: 11,
      trivia: "Virginia is home to both Colonial Williamsburg and Shenandoah National Park."
    },
    %{
      code: "WA",
      name: "Washington",
      row: 0,
      col: 2,
      trivia: "Washington grows more apples than any other state."
    },
    %{
      code: "WV",
      name: "West Virginia",
      row: 3,
      col: 10,
      trivia: "West Virginia is the only state located entirely within the Appalachian Mountain region."
    },
    %{
      code: "WI",
      name: "Wisconsin",
      row: 1,
      col: 8,
      trivia: "Wisconsin is widely known as America’s Dairyland."
    },
    %{
      code: "WY",
      name: "Wyoming",
      row: 1,
      col: 4,
      trivia: "Wyoming was the first state to grant women the right to vote."
    }
  ]

  @states_by_code Map.new(@states, &{&1.code, &1})

  def all, do: Enum.sort_by(@states, & &1.name)
  def codes, do: Map.keys(@states_by_code)
  def get(code), do: Map.get(@states_by_code, String.upcase(code))

  def get!(code) do
    case get(code) do
      nil -> raise ArgumentError, "unknown state code: #{inspect(code)}"
      state -> state
    end
  end
end
