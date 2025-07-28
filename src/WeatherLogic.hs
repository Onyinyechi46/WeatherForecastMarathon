module WeatherLogic (generateForecast) where

generateForecast :: String -> String
generateForecast tempStr =
  case reads tempStr :: [(Float, String)] of
    [(temp, _)]
      | temp > 30 -> "☀️ It's hot and sunny! Stay cool and hydrated."
      | temp > 20 -> "🌤 It's a warm day, perfect for a walk!"
      | temp > 10 -> "☁️ It's cool and possibly cloudy."
      | otherwise -> "❄️ It's cold! Bundle up and stay warm."
    _ -> "⚠️ Invalid temperature input. Please enter a number."
