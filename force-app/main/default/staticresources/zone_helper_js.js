function uuidGroupedByStorey(node) {
  const storeys = [];
  // Recursive helper function
  function traverse(pnode) {
    if (pnode.type === 'storey') {
      storeys.push({
        uuid: pnode.uuid,
        children: pnode.children.map((child) => child.uuid),
      });
    }
    pnode.children.forEach((child) => traverse(child));
  }

  traverse(node);
  return storeys;
}

function countUuidByStorey(storeys, uuids) {
  const storeysInfo = [];

  storeys.forEach((storey) => {
    // Count how many UUIDs in the uuids are in the storey's children
    const uuidCountInStorey = uuids.reduce(
      (count, uuid) => count + storey.children.includes(uuid),
      0,
    );

    if (uuidCountInStorey > 0) {
      storeysInfo.push({
        storeyUUID: storey.uuid,
        uuidCountInStorey,
      });
    }
  });

  return storeysInfo;
}

function findObjectByUUID(objects, uuid) {
  return objects.find((object) => object.uuid === uuid);
}

const uuidsOfZone = (viewerZones, zoneUUID) => {
  const zoneToHighlight = findObjectByUUID(viewerZones, zoneUUID);
  return zoneToHighlight.spaces.map((space) => space.uuid);
};

const isPointInPolygon = (point, polygon) => {
  const { x, y } = point;

  let inside = false;
  // eslint-disable-next-line no-plusplus
  for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    const { x: xi, y: yi } = polygon[i];
    const { x: xj, y: yj } = polygon[j];

    const intersect = ((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
    if (intersect) {
      inside = !inside;
    }
  }
  return inside;
};
