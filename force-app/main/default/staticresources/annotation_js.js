function annotationmgr(zoneId, vfRemote){
  const getAnnotations= () =>{
    return new Promise((resolve, reject) => {
      vfRemote.manager.invokeAction(
        vfRemote.action.getAnnotations,
        zoneId,
        (result, event) => {
          if (event.status) {
            const response = JSON.parse(result);
            console.log('getAnnotations', response);
            // const annotation = this.annotationViewerAdapter(JSON.parse(result));
            resolve(response);
          } else if (event.type === 'exception') {
            reject(new Error(`${event.message} ${event.where}`));
          }
        },
        { buffer: false, escape: false, timeout: 30000 },
      );
    });

  }

  const refreshAnnotations = (viewer) => {
    getAnnotations().then((annotations) => {
      annotations.forEach((annotation, index) => {
        viewer.state.addAnnotation({
          component: annotationComponent,
          props: {
            index: index,
            color: annotation.color,
            tooltip: annotation.name,
          },
          x: parseFloat(annotation.x),
          y: parseFloat(annotation.y),
          z: parseFloat(annotation.z)
        })
      })
    })
  }


  function addAnnotation(viewer, message, color, x, y, z, opts) {
    viewer.state.addAnnotation({
      component: annotationComponent,
      props: {
        index: opts.count,
        color: "#" + color,
        tooltip: message,
      },
      x, y, z
    });
  }
    
  const annotationComponent = {
    props: {
      color: {
        type: String,
        default: 'var(--color-primary)',
      },
      index: {
        type: Number,
        required: true,
      },
      tooltip: {
        type: String,
        required: true,
      },
      url: {
        type: String,
        required: true,
      },
    },
    template: `
      <div class="annotation">
        <div
          class="annotation__pin"
          @click="showTooltip = !showTooltip"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="28"
            height="28"
            viewBox="0 0 28 28"
            fill="none"
          >
            <path
              :fill="color"
              fill-rule="evenodd"
              clip-rule="evenodd"
              d="M4.55 9.95C4.55 4.7255 8.7755 0.5 14 0.5C19.2245 0.5 23.45 4.7255 23.45 9.95C23.45 17.0375 14 27.5 14 27.5C14 27.5 4.55 17.0375 4.55 9.95ZM10.625 9.95013C10.625 11.8131 12.137 13.3251 14 13.3251C15.863 13.3251 17.375 11.8131 17.375 9.95013C17.375 8.08713 15.863 6.57513 14 6.57513C12.137 6.57513 10.625 8.08713 10.625 9.95013Z"
            />
          </svg>
        </div>
        <div v-if="index !== null && index !== undefined">
          <div class="annotation__index">
            {{ index }}
          </div>
        </div>
        <BIMDataCard class="annotation__tooptip" v-if="showTooltip" width="170px" borderRadius="5px">
        <template #content>
          <div class="annotation__tooptip__name">
            {{ tooltip }}
          </div>
        </template>
        </BIMDataCard>
      </div>
    `,
    setup(props, { emit }) {
      const showTooltip = window.BIMDataViewerVue.ref(false);
  
      return {
        showTooltip
      };
    },
  };    
  
  
  const annotationPluginComponentTemplate = () => {
    return `
    <div>
      <BIMDataInput
        v-model="message"
        placeholder='Annotation'
      ></BIMDataInput>
      <div class="flex align-items">
        <span class="m-r-6">Annotation</span>
        <div
          :style="{
            'background-color': '#' + color,
            'width': '20px',
            'height': '20px',
          }"
          @click="displayColorSelector = true"
        ></div>
      </div>
      <BIMDataColorSelector
        v-if="displayColorSelector"
        :modelValue="color"
        @update:modelValue="updateColorSelector($event)"
      />
    </div>
    `
  
  }
  
  const createAnnotation = (annotation) => {
    return new Promise((resolve, reject) => {
      vfRemote.manager.invokeAction(
        vfRemote.action.createAnnotation,
        annotation.zoneId,
        annotation.message,
        annotation.x,
        annotation.y,
        annotation.z,
        annotation.color,
        (result, event) => {
          if (event.status) {
            response = JSON.parse(result);
            console.log('createAnnotation', response);
            // const annotation = this.annotationViewerAdapter(JSON.parse(result));
            resolve(response);
          } else if (event.type === 'exception') {
            reject(new Error(`${event.message} ${event.where}`));
          }
        },
        { buffer: false, escape: false, timeout: 30000 },
      );
    });
  }
  
  
  const annotationPluginComponent = {
    template: annotationPluginComponentTemplate(),
    data() {
      return {
        count: 0,
        color: "7A7A7A",
        message: "",
        displayColorSelector: false,
      };
    },
    mounted() {
      this.viewer = this.$viewer.localContext.plugins.get("viewer3d") ||
                    this.$viewer.localContext.plugins.get("viewer2d");
    },
    onOpen() {
      this.viewer.startAnnotationMode(data => {
        const { x, y, z } = data;
        
        // const pickedZone = getPointZones({x, y}, viewerZones);
        this.count++;
        createAnnotation({zoneId, message: this.message, color: "#" + this.color, x, y, z});
        addAnnotation(this.$viewer, this.message, this.color, x, y, z, {count: this.count})
      });
    },
    onClose() {
      this.viewer.stopAnnotationMode();
    },
    methods: {
      updateColorSelector(color) {
        this.color = color;
        this.displayColorSelector = false;
        console.log(color);
      }
    }
  };
  
  
  const annotationPlugin = {
    name: "annotationPlugin",
    component: annotationPluginComponent,
    addToWindows: ["3d", "2d", "dwg", "plan", "pointCloud", "panorama"],
    button: {
      position: "left",
      content: "simple",
      tooltip: 'Ajouter une annotation',
      keepOpen: true,
      icon: {imgUri: "https://testogg.s3.eu-west-1.amazonaws.com/annotation.svg"}
    }
  };  
  
  return {
    annotationPlugin: annotationPlugin,
    refreshAnnotations: refreshAnnotations

  }
}


