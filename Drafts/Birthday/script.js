// Setup
const scene = new THREE.Scene();
// Add linear fog for nicer depth falloff
scene.fog = new THREE.FogExp2(0x050510, 0.015);

const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });

renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.shadowMap.enabled = true;
renderer.toneMapping = THREE.ReinhardToneMapping;
document.getElementById('canvas-container').appendChild(renderer.domElement);

// Post-Processing (Bloom)
const composer = new THREE.EffectComposer(renderer);
const renderPass = new THREE.RenderPass(scene, camera);
composer.addPass(renderPass);

// Bloom Pass: Resolution, Strength, Radius, Threshold
const bloomPass = new THREE.UnrealBloomPass(new THREE.Vector2(window.innerWidth, window.innerHeight), 1.5, 0.4, 0.85);
bloomPass.threshold = 0;
bloomPass.strength = 1.2; // Glowing intensity
bloomPass.radius = 0.5;
composer.addPass(bloomPass);


// Premium Lighting
const ambientLight = new THREE.AmbientLight(0x4040a0, 0.5); // Blueish tint for night
scene.add(ambientLight);

const directionalLight = new THREE.DirectionalLight(0xffaa33, 1); // Warm light (moon/sun)
directionalLight.position.set(20, 30, 20);
directionalLight.castShadow = true;
directionalLight.shadow.mapSize.width = 2048;
directionalLight.shadow.mapSize.height = 2048;
scene.add(directionalLight);

// Point lights for magical spots
const magicLight = new THREE.PointLight(0x00ffff, 1, 50);
magicLight.position.set(0, 10, 0);
scene.add(magicLight);


// Environment - Stars/Particles (Fireflies)
const firefliesGeometry = new THREE.BufferGeometry();
const firefliesCount = 3000; // More fireflies
const posArray = new Float32Array(firefliesCount * 3);
const scaleArray = new Float32Array(firefliesCount);

for (let i = 0; i < firefliesCount * 3; i++) {
    posArray[i] = (Math.random() - 0.5) * 200;
}
for (let i = 0; i < firefliesCount; i++) {
    scaleArray[i] = Math.random();
}

firefliesGeometry.setAttribute('position', new THREE.BufferAttribute(posArray, 3));
firefliesGeometry.setAttribute('aScale', new THREE.BufferAttribute(scaleArray, 1));

const firefliesMaterial = new THREE.PointsMaterial({
    size: 0.3,
    color: 0xffffaa, // Warm firefly color
    transparent: true,
    opacity: 0.8,
    blending: THREE.AdditiveBlending
});
const fireflies = new THREE.Points(firefliesGeometry, firefliesMaterial);
scene.add(fireflies);


// Stylized Terrain
const planeGeometry = new THREE.PlaneGeometry(300, 300, 128, 128);
const planeMaterial = new THREE.MeshStandardMaterial({
    color: 0x101018, // Darker ground
    roughness: 0.6,
    metalness: 0.4,
    flatShading: true
});

// Terrain Noise
const count = planeGeometry.attributes.position.count;
for (let i = 0; i < count; i++) {
    const x = planeGeometry.attributes.position.getX(i);
    const y = planeGeometry.attributes.position.getY(i);
    // More organic noise
    const z = Math.sin(x / 8) * Math.cos(y / 8) * 3 + Math.sin(x / 2) * Math.cos(y / 2) * 0.5;
    planeGeometry.attributes.position.setZ(i, z);
}
planeGeometry.computeVertexNormals();

const terrain = new THREE.Mesh(planeGeometry, planeMaterial);
terrain.rotation.x = -Math.PI / 2;
terrain.position.y = -2;
terrain.receiveShadow = true;
scene.add(terrain);


// Procedural Landmarks
const landmarksGroup = new THREE.Group();
scene.add(landmarksGroup);

function createLandmark(type, color, x, z) {
    const group = new THREE.Group();
    group.position.set(x, 0, z);

    let geometry, material;
    const baseMaterial = new THREE.MeshStandardMaterial({
        color: color,
        emissive: color,
        emissiveIntensity: 0.8,
        flatShading: true
    });

    if (type === "Eiffel Tower") {
        // Simple stacked geometry
        const base = new THREE.Mesh(new THREE.CylinderGeometry(2, 4, 3, 4), baseMaterial);
        base.position.y = 1.5;
        const mid = new THREE.Mesh(new THREE.CylinderGeometry(0.8, 1.8, 5, 4), baseMaterial);
        mid.position.y = 5.5;
        const top = new THREE.Mesh(new THREE.CylinderGeometry(0, 0.8, 3, 4), baseMaterial);
        top.position.y = 9.5;
        group.add(base, mid, top);
    } else if (type === "Colosseum") {
        // Ring
        const ring = new THREE.Mesh(new THREE.CylinderGeometry(5, 5, 3, 16, 1, true), baseMaterial);
        ring.material.side = THREE.DoubleSide;
        ring.position.y = 2;
        group.add(ring);
    } else if (type === "Taj Mahal") {
        // Dome + Base
        const base = new THREE.Mesh(new THREE.BoxGeometry(6, 3, 6), baseMaterial);
        base.position.y = 1.5;
        const dome = new THREE.Mesh(new THREE.SphereGeometry(2.5, 16, 16, 0, Math.PI * 2, 0, Math.PI / 2), baseMaterial);
        dome.position.y = 3;
        // Minarets
        const minaretGeo = new THREE.CylinderGeometry(0.2, 0.4, 6);
        [[-4, -4], [4, -4], [-4, 4], [4, 4]].forEach(pos => {
            const m = new THREE.Mesh(minaretGeo, baseMaterial);
            m.position.set(pos[0], 3, pos[1]);
            group.add(m);
        });
        group.add(base, dome);
    } else if (type === "NYC") {
        // Cluster of skyscrapers
        for (let i = 0; i < 5; i++) {
            const h = 4 + Math.random() * 6;
            const w = 1 + Math.random();
            const b = new THREE.Mesh(new THREE.BoxGeometry(w, h, w), baseMaterial);
            b.position.set((Math.random() - 0.5) * 4, h / 2, (Math.random() - 0.5) * 4);
            group.add(b);
        }
    } else {
        // Start/Generic
        const gem = new THREE.Mesh(new THREE.OctahedronGeometry(2), baseMaterial);
        gem.position.y = 4;
        group.add(gem);
    }

    return group;
}

const places = [
    { name: "Start", type: "Geneic", x: 0, z: 0, color: 0xffd700 },
    { name: "Paris", type: "Eiffel Tower", x: 10, z: -30, color: 0xff4444 },
    { name: "Rome", type: "Colosseum", x: -15, z: -60, color: 0x44ff44 },
    { name: "Agra", type: "Taj Mahal", x: 20, z: -90, color: 0x4444ff },
    { name: "New York", type: "NYC", x: 0, z: -120, color: 0xff00ff },
];

places.forEach(place => {
    const landmark = createLandmark(place.type, place.color, place.x, place.z);
    landmarksGroup.add(landmark);
});

// Camera Path
const points = places.map(p => new THREE.Vector3(p.x, 5, p.z));
points.forEach((p, i) => {
    if (i % 2 !== 0) p.x += 8;
    p.y = 6 + Math.random() * 4;
});
points.push(new THREE.Vector3(0, 15, -160)); // Fly off into stars

const curve = new THREE.CatmullRomCurve3(points);

// Scroll Logic
gsap.registerPlugin(ScrollTrigger);

const cameraParams = { t: 0 };
const tl = gsap.timeline({
    scrollTrigger: {
        trigger: ".scroll-content",
        start: "top top",
        end: "bottom bottom",
        scrub: 1.5, // Slower, heavier scrub
    }
});

tl.to(cameraParams, {
    t: 1,
    ease: "none",
    onUpdate: () => {
        const position = curve.getPointAt(cameraParams.t);

        // Add "Shake" / Organic movement to the camera base position
        // We handle actual shake in animate loop, here we set the target
        camera.userData.targetPosition = position;

        const lookAtPosition = curve.getPointAt(Math.min(cameraParams.t + 0.05, 1));
        camera.lookAt(lookAtPosition);

        // Move light
        magicLight.position.copy(position);
        magicLight.position.y += 5;
    }
});


// Animation Loop
const clock = new THREE.Clock();

function animate() {
    const elapsedTime = clock.getElapsedTime();
    const deltaTime = clock.getDelta();

    // Fireflies motion
    // We can animate the 'scale' or position slightly? 
    // Ideally we update positions in a vertex shader for performance, but loop is fine for <5k
    // Actually, let's just rotate the whole system slowly
    fireflies.rotation.y = elapsedTime * 0.05;
    fireflies.rotation.z = Math.sin(elapsedTime * 0.1) * 0.1;

    // Camera Shake (Procedural noise)
    if (camera.userData.targetPosition) {
        camera.position.copy(camera.userData.targetPosition);
        camera.position.x += Math.sin(elapsedTime * 0.5) * 0.5;
        camera.position.y += Math.cos(elapsedTime * 0.3) * 0.5;
    }

    // Gentle rotation for landmarks
    landmarksGroup.children.forEach(group => {
        group.rotation.y += 0.005;
        group.position.y = Math.sin(elapsedTime + group.position.x) * 0.5; // Float
    });

    // Post-Processing Render
    composer.render();
    requestAnimationFrame(animate);
}

// Initial position
const startPos = curve.getPointAt(0);
camera.position.copy(startPos);
camera.userData.targetPosition = startPos;
camera.lookAt(curve.getPointAt(0.1));

animate();

// Resize handling
window.addEventListener('resize', () => {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
    composer.setSize(window.innerWidth, window.innerHeight);
});

// Remove loader when loaded
window.addEventListener('load', () => {
    const loader = document.getElementById('loader');
    loader.style.opacity = '0';
    setTimeout(() => {
        loader.style.display = 'none';
        gsap.to('#start-section', { opacity: 1, y: 0, duration: 1 });
    }, 500);
});
