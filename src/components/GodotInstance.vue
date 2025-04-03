<template>
    <div class="godot-container">
      <canvas id="gameplay" ref="gameplay" class="gameplay">
        HTML5 canvas appears to be unsupported in the current browser.<br />
		    Please try updating or use a different browser.
      </canvas>
      <div v-if="loading" class="loading-overlay">
        <slot name="loading">
          Loading...
        </slot>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted, onBeforeUnmount } from 'vue'
  import '../assets/game.js'
  import executable from '../assets/game.wasm?url'
  import mainPack from '../assets/game.pck?url'

  interface Engine {
    canvas: HTMLCanvasElement
    startGame: () => Promise<void>
    unload: () => void
  }
  
  const gameplay = ref<HTMLCanvasElement>()
  const loading = ref(true)
  const engine = ref<Engine>()
  
  const initGodot = async () => {

    try {

      engine.value = new (window as any).Engine({
        canvas: gameplay.value,
        executable: executable.replace('.wasm', ''),
        mainPack,
        unloadAfterInit: false,
        canvasResizePolicy: 2 // 2 = Adaptive (автоматическое масштабирование)
      })
  
      await engine.value!.startGame()
      loading.value = false
      
    } catch (error) {
      console.error('Godot initialization failed:', error)
      loading.value = false
    }
  }
  
  onMounted(async () => {
    await initGodot()
  })
  
  onBeforeUnmount(() => {
    if (engine.value) {
      engine.value.unload()
    }
  })
  </script>
  
  <style scoped>
  .godot-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    overflow: hidden;
  }
  
  .gameplay {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
    outline: none;
    user-select: none;
  }
  
  .loading-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background: rgba(0, 0, 0, 0.7);
    color: white;
    font-family: sans-serif;
    pointer-events: none;
  }
  </style>