module EcwidApi
  class Profile < Entity
    ecwid_reader :generalInfo, :account, :settings, :mailNotifications, :company,
                 :formatsAndUnits, :languages, :shipping, :taxSettings, :zones,
                 :businessRegistrationID, :legalPagesSettings, :payment, :featureToggles,
                 :designSettings, :productFiltersSettings
  end
end
