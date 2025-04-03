declare global {
    interface Window {
      Engine: {
        // Свойства и методы Engine
        init: () => void;
      };
    }
  }