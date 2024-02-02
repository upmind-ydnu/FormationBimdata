      const bimdataViewerConfig = {
        ui: {
          // style: {
          //   backgroundColor: "FFFFFF",
          // },
          headerVisible: false,
          windowManager: false,
          version: false,
          bimdataLogo: false,
          contextMenu: false,
          menuVisible: false,
        },
        plugins: {
          alerts: true,
          bcf: false,
          bcfManager: false,
          buildingMaker: false,
          dwg: true,
          "dwg-layer": true,
          dxf: true,
          equipment2d: false,
          fullscreen: true,
          gauge2d: false,
          ged: true,
          measure2d: false,
          measure3d: false,
          pdfAnnotations: false,
          pdfExport: false,
          pdf: false,
          plan: {
            help: false,
            modelLoader: "hidden",
          },
          viewer3d: {
            help: false,
            modelLoader: 'hidden',
            synchronization: false,
          },
          viewer2d: {
            help: false,
            modelLoader: 'hidden',
            compass: false,
          },        
          panorama: true,
          pointCloud: true,
          pointCloudParameters: true,
          projection: false,
          properties: false,
          search: false,
          section: false,
          smartview: false,
          split: false,
          "storey-selector": false,
          structure: false,
          "structure-properties": true,
          "viewer2d-background": false,
          "viewer3d-background": false,
          "viewer2d-drawer": false,
          "viewer2d-parameters": true,
          "viewer2d-screenshot": false,

          "viewer3d-parameters": true,
          "window-split": true,
        }
      };

      const customLayout = {
          ratios: [30, 70],
          children: [
            "3d",
            "2d"
          ],
        };
