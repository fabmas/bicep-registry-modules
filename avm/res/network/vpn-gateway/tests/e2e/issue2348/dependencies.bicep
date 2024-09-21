@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Optional. The name of the Virtual Hub to create.')
param virtualHubName string

@description('Required. The name of the virtual WAN to create.')
param virtualWANName string

@description('Required. The name of the vpnSite to create.')
param vpnSiteName string

resource virtualWan 'Microsoft.Network/virtualWans@2023-04-01' = {
  name: virtualWANName
  location: location
}

resource virtualHub 'Microsoft.Network/virtualHubs@2022-01-01' = {
  name: virtualHubName
  location: location
  properties: {
    virtualWan: {
      id: virtualWan.id
    }
    addressPrefix: '10.1.0.0/16'
  }
}

resource vpnSite 'Microsoft.Network/vpnSites@2024-01-01' = {
  name: vpnSiteName
  location: location
  properties: {
    virtualWan: {
      id: virtualWan.id
    }
    deviceProperties: {
      deviceVendor: 'Cisco'
      deviceModel: 'ASA 5500'
      linkSpeedInMbps: 100
    }
    vpnSiteLinks: [
      {
        name: 'link1'        
      }
    ]
  }
}


@description('The resource ID of the created Virtual Hub.')
output virtualHubResourceId string = virtualHub.id

@description('The resource ID of the created Virtual WAN.')
output virtualWanbResourceId string = virtualWan.id
