module System.Taffybar.Widget.NetworkGraph where

import qualified GI.Gtk
import System.Taffybar.Context
import System.Taffybar.Hooks
import System.Taffybar.Information.Network
import System.Taffybar.Widget.Generic.ChannelGraph
import System.Taffybar.Widget.Generic.Graph

logScale :: Double -> Double -> Double -> Double
logScale base maxValue value =
  logBase base (min value maxValue) / actualMax
    where actualMax = logBase base maxValue

networkGraphNew :: GraphConfig -> Maybe [String] -> TaffyIO GI.Gtk.Widget
networkGraphNew config interfaces = do
  NetworkInfoChan chan <- getNetworkChan
  let filterFn = maybe (const True) (flip elem) interfaces
      getUpDown = sumSpeeds . map snd . filter (filterFn . fst)
      toLogScale = logScale 2 (2 ** 32)
      toSample (up, down) = map (toLogScale . fromRational) [up, down]
      sampleBuilder = return . toSample . getUpDown
  channelGraphNew config chan sampleBuilder
