function getCallerLocation(): string {
  const stack = new Error().stack;
  if (!stack) return '';

  const stackLines = stack.split('\n');
  // Line 0 = 'Error'
  // Line 1 = this function (getCallerLocation)
  // Line 2 = the logger method (info/warn/error)
  // Line 3 = the actual caller
  const callerLine = stackLines[3] || '';
  const match = callerLine.match(/\(([^)]+)\)/);
  let location = match?.[1] || callerLine.trim();

  // Normalize paths
  location = location.replace('file://', '').replace(/\\/g, '/');

  // Dynamically trim off everything before project root
  const projectRoot = process.cwd().replace(/\\/g, '/'); // Normalize slashes
  if (location.startsWith(projectRoot)) {
    location = location.slice(projectRoot.length + 1); // +1 to remove the leading slash
  }

  return location;
}


export const logger = {
  info: (message: string, ...args: any[]) => {
    const location = getCallerLocation();
    console.log(`[INFO] ${message} (${location})`, ...args);
  },
  warn: (message: string, ...args: any[]) => {
    const location = getCallerLocation();
    console.warn(`[WARN] ${message} (${location})`, ...args);
  },
  error: (message: string, ...args: any[]) => {
    const location = getCallerLocation();
    console.error(`[ERROR] ${message} (${location})`, ...args);
  },
};