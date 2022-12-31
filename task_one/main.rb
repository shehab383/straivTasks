# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'ostruct'

def main
  doc = Nokogiri::XML(open('xml_compressed.xml'))

  hotel_res = Nokogiri::Slop <<~EOXML
    #{doc.xpath('/soapenv:Envelope/soapenv:Body/i:OTA_HotelResNotifRQ/i:HotelReservations/i:HotelReservation', 'i' => 'http://www.opentravel.org/OTA/2003/05', 'soapenv' => 'http://www.w3.org/2003/05/soap-envelope')}
  EOXML
  # parse each xml entry into hash
  xml_hash = {}
  xml_hash[:id] =
    hotel_res.HotelReservation.ResGlobalInfo.HotelReservationIDs.HotelReservationID("[@ResID_Type='10']")[:ResID_Value]
  xml_hash[:external_id] =
    hotel_res.HotelReservation.ResGlobalInfo.HotelReservationIDs.HotelReservationID("[@ResID_Type='16']")[:ResID_Value]
  xml_hash[:state] = hotel_res.HotelReservation[:ResStatus]
  rate_plan = hotel_res.HotelReservation.RoomStays.RoomStay.RatePlans.RatePlan
  xml_hash[:rate_plan] =
    [{ RatePlanDescription: rate_plan.RatePlanDescription.content.strip },
     RatePlanInclusions: { TaxInclusive: rate_plan.RatePlanInclusions[:TaxInclusive] },
     MealsIncluded: { MealPlanIndicator: rate_plan.MealsIncluded[:MealPlanIndicator] }]
  xml_hash[:services] = hotel_res.HotelReservation.RoomStays.RoomStay.Services.Service.map(&:content)
rescue StandardError
  # nothing to rescue
ensure
  # create new ostruct object from hash
  xml_ostruct = OpenStruct.new(xml_hash)
  print xml_ostruct
end

main
