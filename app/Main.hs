{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Network.Wai.Middleware.Static
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html.Renderer.Text as R
import qualified Text.Blaze.Html5.Attributes as A
import qualified Data.Text.Lazy as TL
import qualified Data.Text as T
import Data.Time (getCurrentTime, formatTime, defaultTimeLocale)
import WeatherLogic

main :: IO ()
main = scotty 3000 $ do
  middleware $ staticPolicy (addBase "static")

  -- Home Page
  get "/" $ do
    html $ R.renderHtml $
      H.html $ do
        H.head $ do
          H.title "Weather Forecast"
          H.meta H.! A.name "viewport" H.! A.content "width=device-width, initial-scale=1.0"
          H.link H.! A.rel "stylesheet" H.! A.href "/style.css"
        H.body H.! A.class_ "fade-in" $ do
          H.h1 "🌤 Welcome to Weather Forecast"
          H.form H.! A.action "/forecast" H.! A.method "post" $ do
            H.p "Enter Your Country:"
            H.input H.! A.type_ "text" H.! A.name "country" H.! A.placeholder "e.g. Nigeria"
            H.p "Enter Temperature (°C):"
            H.input H.! A.type_ "text" H.! A.name "temp" H.! A.placeholder "e.g. 25"
            H.br
            H.input H.! A.type_ "submit" H.! A.value "Get Forecast"

  -- Forecast Result Page
  post "/forecast" $ do
    countryStr <- formParam "country"
    tempStr    <- formParam "temp"
    currentTime <- liftIO getCurrentTime

    let forecast  = generateForecast (T.unpack $ TL.toStrict tempStr)
        country   = TL.toStrict countryStr
        timeStr   = formatTime defaultTimeLocale "%A, %d %B %Y %H:%M:%S" currentTime

    html $ R.renderHtml $
      H.html $ do
        H.head $ do
          H.title "Forecast Result"
          H.meta H.! A.name "viewport" H.! A.content "width=device-width, initial-scale=1.0"
          H.link H.! A.rel "stylesheet" H.! A.href "/style.css"
        H.body H.! A.class_ "fade-in" $ do
          H.h2 $ H.toHtml $ "📍 Forecast for " <> country
          H.div H.! A.class_ "result-box" $ do
            H.p (H.toHtml forecast)
            H.p $ H.toHtml ("🕒 " ++ timeStr)
            H.a H.! A.href "/" H.! A.class_ "back-btn" $ "🔙"
