### afﬁne transformation:      
    A transformation that preserves straight lines and the ratio of distances of points lying on lines. 

### aliasing:
    Artifacts created by undersampling a scene, typically caused by assigning one point sample per pixel, where there are edges or patterns in the scene of higher frequency than the pixels. This results in jagged edges (jaggies), moiré patterns, and scintillation. See antialiasing. 

### alpha:
    The fourth color component. The alpha component is never displayed directly, and is typically used to control blending of colors. By convention, OpenGL alpha corresponds to the notion of opacity, rather than transparency, meaning that an alpha value of 1.0 implies complete opacity, and an alpha value of 0.0 complete transparency. 

### ambient:    
    Ambient light is light not directly associated with a light source, and is distributed uniformly throughout space, with light falling upon a surface approaching from all directions. The light is reflected from the object independent of surface location and orientation, with equal intensity in all directions. 

### amplication:    
    The process of a geometry shader creating more geometry than was passed to it. 

### animation:     
    Generating repeated renderings of a scene, with smoothly changing viewpoint and object positions, quickly enough so that the illusion of motion is achieved. OpenGL animation is almost always done using double-buffering. 

### anisotropic ﬁltering:
    A texture-filtering technique that improves image quality by sampling the texture using independent texture-interpolation rates for each texture dimension. 

### antialiasing:   
Rendering techniques that reduce aliasing. These techniques include sampling at a higher frequency, assigning pixel colors based on the fraction of the pixel’s area covered by the primitive being rendered, removing high-frequency components in the scene, and integrating or averaging the area of the scene covered by a pixel, as in area sampling. See antialiasing. 

### API:
   See application programming interface. 

### application programming interface:
    A library of functions and subroutines that an application makes calls into. OpenGL is an example of an application programming interface. 

### area sampling:
Deciding what color to color a pixel based on looking at the entire content of the scene covered by the pixel. This is as opposed to point sampling . 

### array textures:
    Array textures are texture objects that contain multiple layers or slices that are treated as one associated block of data. 

### atomic counter:
    A counter object usable in all of OpenGL’s shader stages that is updated atomically. See atomic operation. 

### atomic operation:
    In the context of concurrent (multithreaded) programming, an operation that is always completed without interruption. 

### attenuation:
    The property of light that describes how a light’s intensity diminishes over distance. 

### back faces:
    See faces. 

### barycentric coordinates:
    A coordinate system where a point is represented as a weighted sum of two or more reference points. Varying a barycentric coordinate between zero and one in each component moves it within its domain. 

### Bernstein polynomials:
    A family of polynomial equations named after Sergei Natanovich Bernstein that are used in evaluating Bézier curves. The polynomials are defined as follows: 
    bn,m (x) =  n 	xn  (1 − x)n−m 
            m 
    where  n  is a binomial coefficient. 
            m 

### billboard:
    Usually a texture-mapped quadrilateral that is oriented to be perpendicular to the viewer. Often billboards are used to approximate complex geometry at a distance. 


### binding an object:
    Attaching an object to the OpenGL context, commonly through a function that starts with the word bind, such as glBindTexture(), glBindBuffer(), or glBindSampler(). 

### binomial coefﬁcient:
    The coefficients of the terms in the expansion of the polynomial (1 + x)n . Binomial coefficients are often described using 
                        
      the notation     n , where 
                       k 
                                       	 
                                       n          n! 
                                           = 
                                       k      k!(n − k)! 

      where n! is the factorial of n. 

### binormal:
    A vector perpendicular to both a surface tangent vector and the surface normal vector. These three mutually orthogonal vectors can form the basis of a local coordinate system, including a surface-local coordinate space. 

### bit:
    A short form for ‘‘binary digit’’. A state variable having only two possible values: 0 or 1. Binary numbers are constructions of one or more bits. 

### bit depth:
    The number of bits available for a particular component, limiting the set of values that can be stored in the component. 

bitplane    A rectangular array of bits mapped one-to-one with pixels. The 
      framebuffer can be considered a stack of bitplanes. 

blending     Reduction of two color components to one component, usually 
      as a linear interpolation between the two components. 

buffer   A group of bitplanes that store a single component, such as depth 
      or green. Sometimes the red, green, blue, and alpha buffers together 
      are referred to as the color buffer, rather than the color buffers. 

buffer object    A buffer located in the OpenGL’s server memory. Vertex 
      and pixel data, uniform variables, and element-array indices may be 
      stored in buffer objects. 

buffer objects     Objects representing linear allocations of memory that 
      may be used to store data. 

buffer ping-ponging       A technique---mostly used for GPGPU---where two 
      equally sized buffers are used accumulating results. For a particular 
      frame, one buffer holds current results and is read from, and the 
      other buffer is written to updating those results. For the next frame, 
      the buffers’ roles are swapped (ping-ponged). 

bump map       See normal map. 

         bump mapping       Broadly, this is adding the appearance of bumps through 
              lighting effects even though the surface being rendered is flat. This is 
              commonly done using a normal map to light a flat surface as if it were 
              shaped as dictated by the normal map, giving lighting as if bumps 
              existed on the surface, even though there is no geometry describing 
              the bumps. 

         byte swapping     The process of exchanging the ordering of bytes in a 
               (usually integer) variable type (i.e., int, short, etc.). 

         C   The programming language of Unix kernel hackers. 

         C++   Most common programming language for programming computer 
              graphics. 

         cascading style sheet     A presentation mechanism for specifying the look 
              and layout of Web pages. 

         client  The computer from which OpenGL commands are issued. The 
              client may be the same computer that the OpenGL server is running 
              on (see server), or it may be a different machine connected via a 
              network (assuming the OpenGL implementation supports network 
              rendering). 

         clip  See clipping. 

         clip coordinates    The coordinate system that follows transformation by 
              the projection matrix and precedes perspective division. View- 
              volume clipping is done in clip coordinates. 

         clipping   Elimination of the portion of a geometric primitive that’s 
              outside the half-space defined by a clipping plane. Points are simply 
              rejected if outside. The portion of a line or triangle that’s outside the 
              half-space is eliminated, and additional vertices are generated as 
              necessary to complete the primitive within the clipping half-space. 
              Geometric primitives are always clipped against the six half-spaces 
              defined by the left, right, bottom, top, near, and far planes of the view 
              volume. Applications can optionally perform application-specific 
              clipping through use of clip distances, gl_ClipDistance[]. 

         clipping region    The intersection of all the half-spaces defined by the 
              clipping planes. See clipping. 

         CMYK     Cyan, Magenta, Yellow, Black. A color space often used in printing. 

         color space    A model for describing colors, often as vectors within a 
              three- or four-dimensional domain such as the RGB color space . 

compatibility proﬁle    The profile of OpenGL that still supports all legacy 
      functionality. It is primarily intended to allow the continued 
      development of older applications. See also core profile. 

components      Individual scalar values in a color or direction vector. They 
      can be integer or floating-point values. Usually, for colors, a 
      component value of zero represents the minimum value or intensity, 
      and a component value of one represents the maximum value or 
      intensity, although other ranges are sometimes used. Because 
      component values are interpreted in a normalized range, they are 
      specified independent of actual resolution. For example, the RGB 
      triple (1,1,1) is white, regardless of whether the color buffers store 4, 
      8, or 12 bits each. Out-of-range components are typically clamped to 
      the normalized range, not truncated or otherwise interpreted. For 
      example, the RGB triple (1.4,1.5,0.9) is clamped to (1.0,1.0,0.9) before 
      it’s used to update the color buffer. Red, green, blue, alpha, and depth 
      are always treated as components, never as indices. 

compressed texture      A texture image which is stored in a compressed 
      form. Compressed textures benefit from requiring less memory, and 
      using texture-cache memory more efficiently. 

compression      Reducing the storage requirements of data by changing its 
      representation in memory. 

compression ratio     The ratio of the amount of storage required for some 
      compressed data relative to the size of the original, uncompressed 
      data. 

compute shader      A shader that is executed as the result of a compute 
      dispatch command. A single invocation of a compute shader 
      represents one work item and a group of invocations forms a local 
      workgroup. A number of local workgroups form a global workgroup . 

concave    A polygon that is not convex. See convex. 

conditional rendering     A technique of impliclitly using occlusion queries 
      to determine if a sequence of OpenGL rendering commands should 
      be executed based on their visibility (as predicated by depth testing). 

constructor    A function used for initializing an object. In GLSL, cons- 
      tructors are used to both initialze new objects (e.g., vec4 ), but also 
      convert between types. 

context   A complete set of OpenGL state variables. Note that framebuffer 
      contents are not part of OpenGL state, but that the configuration of 
      the framebuffer (and any associated renderbuffers) is. 

        control texture    A texture that tells the shader where an effect should be 
              done, or that otherwise controls how and where an effect is done, 
              rather than simply being an image. This is likely to be a single- 
              component texture. 

        convex     A polygon is convex if no straight line in the plane of the 
              polygon intersects the polygon’s edge more than twice. 

        convex hull    The smallest convex region enclosing a specified group of 
              points. In two dimensions, the convex hull is found conceptually by 
              stretching a rubber band around the points so that all of the points 
              lie within the band. 

        convolution     A mathematical function that combines two functions such 
              that evaluating the combined function at a point returns the area of 
              the overlap of the two input functions. Convolutions in graphics are 
              usually used in image processing operations. 

        convolution ﬁlter    In image processing, a two-dimensional array of values 
              which are used in a convolution operation on the pixels of an image. 

        convolution kernel     See convolution filter. 

        coordinate system      In n-dimensional space, a set of n linearly indepen- 
              dent basis vectors anchored to a point (called the origin). A group of 
              coordinates specifies a point in space (or a vector from the origin) by 
              indicating how far to travel along each vector to reach the point (or 
              tip of the vector). 

        core proﬁle    The modern, streamlined profile of OpenGL that should be 
              used for new application development. See also compatibility profile. 

        cracking    Gaps that appear between edges of adjoining, filled geometric 
              primitives. Cracking can occur during tessellation when the 
              tessellation levels of two adjoining edges are not equal. 

        cube map     A type of texture that has a multiple of six square faces that 
              may be used to provide environment maps and other effects in 
              OpenGL. 

        culling   Removing objects that shouldn’t be or don’t need to be rendered. 
              They can be geometric primitives outside the view frustum, the 
              nonvisible front or back face of a polygon, a fragment outside the 
              viewport, etc. 

        current    The state used to describe when an OpenGL object is active, 
              either for use or modification. For instance, a texture is made current 
              by calling glBindTexture(), after which time, it can be modified, 
              such as changing its minification filter. 

debug context     An OpenGL context that automatically reports errors to 
      simplify debugging of OpenGL applications. 

decal   A method of calculating color values during texture application, 
      where the texture colors replace the fragment colors or, if alpha 
      blending is enabled, the texture colors are blended with the fragment 
      colors, using only the alpha value. 

default framebuffer    The framebuffer object with name zero that’s created 
      for every OpenGL application. Its color buffer is the only one that 
      can be displayed to the physical screen. 

deprecated    The identification of a function entry point, or feature 
      exposed as a token passed into a function call, that is slated for 
      potential removal in future versions of an API  or language. Use of the 
      feature is still legal, but will suffer from reduced support and 
      interaction with new features. 

depreciation model     The plan used for the identification and potential 
      removal of features from the OpenGL library. The depreciation model 
      was introduced with Version 3.0, and the first features were removed 
      from the API in Version 3.1. 

depth   Generally refers to the z window coordinate. See depth value. 

depth buffer   Memory that stores the depth value at every pixel. To 
      perform hidden-surface removal, the depth buffer records the depth 
      value of the object that lies closest to the observer at every pixel. The 
      depth value of every new fragment uses the recorded value for depth 
      comparison and must pass the comparison test before being rendered. 

depth range    The portion of the z direction (range of z coordinates) that 
      will be rendered for a scene. OpenGL takes a near and far parameter 
      to describe this range. Goes hand-in-hand with your viewport. 

depth testing   Comparison of a fragment’s depth coordinate against that 
      stored in the depth buffer. The result of this test may then be used to 
      control further rendering---say to discard the fragment, or to control 
      how the stencil buffer is updated. 

depth texture    A texture map composed of depth values---as compared to 
      colors---often used in generating shadows. 

depth value    The depth coordinate of a fragment, or a value stored in the 
      depth buffer. 

destination-blending factor    The coefficient associated with the color 
      stored in the frame buffer used for blending. 


        diffuse   Diffuse lighting and reflection account for the direction of a light 
              source. The intensity of light striking a surface varies with the angle 
              between the orientation of the object and the direction of the light 
              source. A diffuse material scatters that light evenly in all directions. 

        directional light source    See infinite light source. 

        displacement mapping        Use of a texture or other data source to move the 
              vertices of a tessellated object along the surface normal to give the 
              appearance of a bumpy finish. 

        display    The device used to show the image to the user, usually a 
              computer monitor, projector, or television. Also refers to the final 
              framebuffer into which a computer image is rendered. 

        display callback    A function that is called by an application framework 
              whenever it is time to render a new frame of animation. 

        dithering   A technique (no longer used on modern graphics displays) for 
              increasing the perceived range of colors in an image at the cost of 
              spatial resolution. Adjacent pixels are assigned differing color values; 
              when viewed from a distance, these colors seem to blend into a single 
              intermediate color. The technique is similar to the half-toning used 
              in black-and-white publications to achieve shades of gray. 

        double buffering     OpenGL contexts supporting both front and back color 
              buffers are double-buffered. Smooth animation is accomplished by 
              rendering into only the back buffer (which isn’t displayed), and then 
              causing the front and back buffers to be swapped. See 
              glutSwapBuffers() in Appendix A. 

        dual-source blending      A blending mode where the fragment shader 
              outputs two colors: one to be used as the source color in blending, 
              and the other as one of the blending factors (either soruce or 
              destination). 

        dynamically uniform      In GLSL, a dynamically uniform expression is one 
              where each shader invocation evaluating that expression will 
              generate the same value as a result. 

        emission     The color of an object that is self-illuminating or self-radiating. 
              The intensity of an emissive material is not attributed to any external 
              light source. 

        environment map       A texture used to color surfaces to make them appear 
              to be more integrated into their environment. 

        environment mapping        The application of an environment map. 


event loop    In event-based applications, the event loop is a loop in the 
      program that continuously checks for the arrival of new events and 
      decides how to handle them. 

exponent     Part of a floating-point number, the power of two to which the 
      mantissa is raised after normalization. 

eye coordinates     The coordinate system that follows transformation by 
      the model-view matrix, and precedes transformation by the 
      projection matrix. Lighting and application-specific clipping are 
      done in eye coordinates. 

eye space    See eye coordinates. 

faces   Each polygon has two faces: a front face and a back face. Only one 
      face is ever visible in the window at a time. Whether the front or back 
      face is visible is effectively determined after the polygon is projected 
      onto the window. After this projection, if the polygon’s edges are 
      directed clockwise, one of the faces is visible; if directed 
      counterclockwise, the other face is visible. Whether clockwise 
      corresponds to front or back (and counterclockwise corresponds to 
      back or front) is determined by the OpenGL programmer. 

factorial  For nonnegative integers, the factorial of n (denoted as n!) is the 
      product of the integer values from n to 1, inclusive. 

far plane   One of the six clipping planes of the viewing frustum. The far 
      plane, is the clipping plane farthest from the eye and perpendicular 
      to the line-of-sight. 

feedback    Modes of operation for OpenGL, where the results of rendering 
      operations, such as transformation of data by a vertex shader, are 
      returned to the application. 

ﬁltering   The process of combining pixels or texels to obtain a higher or 
      lower resolution version of an input image or texture. 

ﬁxed-function pipeline     A version of the graphics pipeline that contained 
      processing stages whose operation were controlled by a fixed number 
      of parameters that the application could configure. Programmable 
      pipelines, like the current OpenGL pipeline, that allowed more 
      flexibilty in operation have replaced the fixed-function versions. 

ﬂat shading    Refers to a primitive colored with a single, constant color 
      across its extent, rather than smoothly interpolated colors across the 
      primitive. See Gouraud shading. 


         fonts   Groups of graphical character representations generally used to 
               display strings of text. The characters may be roman letters, 
               mathematical symbols, Asian ideograms, Egyptian hieroglyphics, and 
               so on. 

         fractional Brownian motion       A procedural-texturing technique to produce 
               randomized noise textures. 

         fragment    Fragments are generated by the rasterization of primitives. Each 
               fragment corresponds to a single pixel and includes color, depth, and 
               sometimes texture-coordinate values. 

         fragment discard     The execution of the discard; keyword in a fragment 
               shader is known as fragment discard. It causes the fragment to have 
               no effect on the framebuffer, including depth, stencil, and any 
               enabled color attachments. 

         fragment shader      The shader that is executed as a result of rasterization. 
               One invocation of the fragment shader is executed for each fragment 
               that is rasterized. 

         fragment shading      The process of executing a fragment shader. 

         framebuffer    All the buffers of a given window or context. Sometimes 
               includes all the pixel memory of the graphics hardware accelerator. 

         framebuffer attachment       A connection point in a framebuffer object that 
               makes an association between allocated image storage (which might 
               be a texture map level, a renderbuffer, pixel buffer object, or any of 
               the other types of object storage in OpenGL), and a rendering target, 
               such as a color buffer, the depth buffer, or the stencil buffer. 

         framebuffer object     The OpenGL object that stores all of the associated 
               render buffers for a framebuffer. 

         framebuffer rendering loop       The condition where a framebuffer 
               attachment is both simultaneously being written and read. This 
               situation is undesirable, and should be avoided. 

         Freeglut   An open-source implemetation of the OpenGL Utility Toolkit 
               written by Pawel W. Olszta and others that is an up-to-date version of 
               the original GLUT library by Mark Kilgard. 

         frequency clamping      A technique used during procedural texturing to 
               represent complex functions in a simpler form. 

         front faces   See faces. 

		 
front facing   The classification of a polygon’s vertex ordering. When the 
      screen-space projection of a polygon’s vertices is oriented such that 
      traveling around the vertices in the order they were submitted to 
      OpenGL results in a counterclockwise traversal (by definition, 
      glFrontFace() controls which faces are front facing). 

frustum    The view volume warped by perspective division. 

function overloading      The technique of modern programming lanugages 
      where functions with the same name accept different numbers of 
      parameters or data types. 

gamma correction       A function applied to colors stored in the framebuffer 
      to correct for the nonlinear response of the eye (and sometimes of 
      the monitor) to linear changes in color-intensity values. 

gamut    The subset of all possible colors that can be displayed in a certain 
      color space. 

geometric model       The object-coordinate vertices and parameters that 
      describe an object. Note that OpenGL doesn’t define a syntax for 
      geometric models, but rather a syntax and semantics for the 
      rendering of geometric models. 

geometric object      See geometric model . 

geometric primitive     A point, a line, or a triangle. 

global illumination     A rendering technique that illumates a scene using all 
      available light sources, including reflections. This technique is 
      generally not possible in rasterization-based systems. 

global workgroup      The complete set of work items that are dispatched by 
      a single call to glDispatchCompute(). The global workgroup is 
      comprised of an integer number of local workgroups in the x, y, and z 
      dimensions. 

GLSL     OpenGL Shading Language 


GLUT     the OpenGL Utility Toolkit 

GLX    The window system interface for OpenGL on the X Window System. 

Gouraud shading       Smooth interpolation of colors across a polygon or line 
      segment. Colors are assigned at vertices and linearly interpolated 
      across the primitive to produce a relatively smooth variation in color. 
      Also called smooth shading. 
	  
        GPGPU     The short name for General-Purpose computing on GPUs, which 
              is the field of techniques attempting to do general computation 
              (algorithms that you would normally execute on a CPU) on graphics 
              processors. 

        GPU    graphics processing unit 

        gradient noise    Another name for Perlin noise . 

        gradient vector   A vector directed along the directional-derivative of a 
              function. 

        graphics processing     The tasks involved in producing graphical images 
              such as vertex processing, clipping, rasterization, tessellation, and 
              shading. 

        graphics processing unit     A term used to describe the subsection of a 
              computer system comprising one or more integrated circuits that are 
              at least partially dedicated for the generation of graphical images. 

        half space   A plane divides space into two half spaces. 

        halo   An illumination effect that simulates light shining behind an object 
              that produces a halo-like appearance around the object’s silhouette. 

        hidden-line removal    A technique to determine which portions of a 
              wireframe object should be visible. The lines that comprise the 
              wireframe are considered to be edges of opaque surfaces, which may 
              obscure other edges that are farther away from the viewer. 

        hidden-surface removal     A technique to determine which portions of an 
              opaque, shaded object should be visible, and which portions should 
              be obscured. A test of the depth coordinate, using the depth buffer 
              for storage, is a common method of hidden-surface removal. 

        homogeneous coordinate        A set of n + 1 coordinates used to represent 
              points in n-dimensional projective space. Points in projective space 
              can be thought of as points in Euclidean space together with some 
              points at infinity. The coordinates are homogeneous because a scaling 
              of each of the coordinates by the same nonzero constant doesn’t alter 
              the point that the coordinates refer to. Homogeneous coordinates are 
              useful in the calculations of projective geometry, and thus in 
              computer graphics, where scenes must be projected onto a window. 

        image    A rectangular array of pixels, either in client memory or in the 
              framebuffer. 

image plane     Another name for the clipping plane of the viewing frustum 
      that is closest to the eye. The geometry of the scene is projected onto 
      the image plane, and displayed in the application’s window. 

image-based lighting      An illumination technique that uses an image of 
      the light falling on an object to illuminate the object, as compared to 
      directly computing the illumation using analytical means. 

immutable     The state of being unmodifiable. Applied to textures, it means 
      that the parameters of the texture (width, height, and storage format) 
      cannot be changed. 

impostor    A simplified model of a complex geometric object, often using 
      a single, texture-mapped polygon. 

inﬁnite light source    A directional source of illumination. The radiating 
      light from an infinite light source strikes all objects as parallel rays. 

input-patch vertex    The input vertices that form a patch primitive. After 
      processing by the vertex shader, these are passed to the tessellation 
      control shader where they may be used as control points in the 
      representation of a high-order-surface. 

instance id   An identifier available in vertex shaders for identifying a 
      unique group of primitives. In GLSL, the instance id is provided in 
      the monotonically increasing variable gl_InstanceID. 

instanced rendering      Drawing multiple copies of the same set of 
      geometry, varying a unique identifier for each copy of the geometry. 
      See instance id. 

interface block    The grouping of shader variables between two successive 
      shader stages. 

interleaved    A method of storing vertex arrays by which heterogeneous 
      types of data (i.e., vertex, normals, texture coordinates, etc.) are 
      grouped for faster retrieval. 

internal fomat    The storage format used by OpenGL for storing a texture 
      map. A texture’s internal format is often different than the format of 
      the pixels passed to OpenGL. 

interpolation   Calculation of values (such as color or depth) for interior 
      pixels, given the values at the boundaries (such as at the vertices of a 
      polygon or a line). 

invocation    A single execution of a shader. In tessellation control shaders, 
      it represents a single control point. In geometry shaders, it represents 

              a single instance of the shader when instancing is turned on. In 
              compute shaders, a single invocation is created for each work item. 

         IRIS GL   Silicon Graphics’ proprietary graphics library, developed from 
              1982 through 1992. OpenGL was designed with IRIS GL as a starting 
              point. 

        jaggies    Artifacts of aliased rendering. The edges of primitives that are 
              rendered with aliasing are jagged, rather than smooth. A 
              near-horizontal aliased line, for example, is rendered as a set of 
              horizontal lines on adjacent pixel rows, rather than as a smooth, 
              continuous line. 

         lacunarity   A multipler that determines how quickly the freqeuncy 
              increases for each successive octave for Perlin noise. 

         layout qualiﬁer   A declaration associated with the inputs, outputs, or 
              variables in a shader that describe how they are laid out in memory, 
              or what the logical configuration of that shader is to be. 

         lens ﬂare   An illumination effect that simulates the light scattered 
              through a lens. 

         level of detail The process of creating multiple copies of an object or 
              image with different levels of resolution. See mipmap. 

         light probe   A device for capturing the illumination of a scene. A common 
              physical light probe is a reflective hemisphere. 

         light probe image    The image collected by a light probe. 

         lighting  The process of computing the color of a vertex based on current 
              lights, material properties, and lighting-model modes. 

         line  A straight region of finite width between two vertices. (Unlike 
              mathematical lines, OpenGL lines have finite width and length.) 
              Each segment of a strip of lines is itself a line. 

         local light source   A source of illumination that has a position instead of 
              a direction. The radiating light from a local light source emanates 
              from that position. Other names for a local light source are point 
              light source or positional light source. A spotlight is a special kind of 
              local light source. 

         local viewer   The mode of the Phong lighting model that more accurately 
              simulates how specular highlights shine on objects. 

local workgroup      The local scope of a workgroup that has access to the 
      same set of shared local variables. 

logical operation     Boolean mathematical operations between the 
      incoming fragment’s RGBA color or color-index values and the RGBA 
      color or color-index values already stored at the corresponding 
      location in the framebuffer. Examples of logical operations include 
      AND, OR, XOR, NAND, and INVERT. 

lossless compression        Any method of compressing data where the 
      original data may be retrieved without any loss of information. 

lossy compression       Any method of compressing data where some of the 
      original information is discarded in order to improve the 
      compression ratio. 

low-pass ﬁltering     Taking a scene and keeping the low-frequency 
      components (slower spatial variation) while discarding the 
      high-frequency components. This is one way to avoid undersampling, 
      by bringing the highest frequency present down to the level that 
      sampling will be done. 

luminance     The perceived brightness of a surface. Often refers to a 
      weighted average of red, green, and blue color values that indicates 
      the perceived brightness of the combination. 

machine word       A unit of processing as seen by computer systems---usually 
      represented by a single register in a processor. For example, 32-bit 
      systems generally have a 32-bit machine word and 32-bit wide 
      registers. 

mantissa     Part of a floating-point number, represents the numeric 
      quantity that is subsequently normalized and raised to the power of 
      two represented by the exponent. 

material    A surface property used in computing the illumination of a 
      surface. 

matrix    A two-dimensional array of values. OpenGL matrices are all 4 × 4, 
      though when stored in client memory they’re treated as 1 × 16 
      single-dimension arrays. 

mipmap      A reduced resolution version of a texture map, used to texture a 
      geometric primitive whose screen resolution differs from the 
      resolution of the source texture map. 

models     Sets of geometric primitives representing objects, often including 
      texture coordinate (and textures), normals, and other properties. 

        modulate     A method of calculating color values during texture application 
              by which the texture and the fragment colors are combined. 

        monitor    The device that displays the image in the framebuffer. 

        multifractal   A procedural-texturing technique that varies the fractal 
              dimension of the noise function based on an object’s location. 

        multisampling     The process of generating or producing multiple samples 
              per pixel. 

        multitexturing    The process of applying several texture images to a single 
              primitive. The images are applied one after another, in a pipeline of 
              texturing operations. 

        mutable    Capable of being modified, usually in reference to a texture 
              map. See immutable. 

        name     In OpenGL, a name is an unsigned integer representing an 
              instance of an object (texture or buffer, for example). 

        NDCs     Normalized Device Coordinates. 

        near plane    One of the six clipping planes of the viewing frustum. The 
              near plane, which is also called the image plane is the clipping plane 
              closest to the eye and perpendicular to the line-of-sight. 

        network    A connection between two or more computers that enables each 
              to transfer data to and from the others. 

        noise   A repeatable pseudo-random deviance as a function of an input 
              location, used to modify surface colors and geometries to give a less 
              than perfect look, such as to make stains, clouds, turbulence, wood 
              grain, etc., that are not based on rigid, detectable patterns. 

        nonconvex     A polygon is nonconvex if a line exists in the plane of the 
              polygon that intersects the polygon more than twice. See concave. 

        normal    The short form for a surface normal, and a synonym for 
              perpendicular. 

        normal map     A map saying for each location on a surface how much an 
              apparent surface normal should deviate from the true surface normal. 
              This is typically used when bump mapping. Usually, the normal is 
              stored as a relative vector for a surface-local coordinate space where the 
              vector (0,0,1) is assumed to be the base surface normal. 

        normal texture    A normal map stored as a texture. 

normal vector      See normal. 

normalize     To change the length of a vector to have some canonical form, 
      usually to have a length 1.0. The GLSL built-in normalize does this. 
      To normalize a normal vector, divide each of the components by the 
      square root of the sum of their squares. Then, if the normal is 
                                                                               
      thought of as a vector from the origin to the point (nx , ny , nz ), this 
      vector has unit length. 
                               factor = nx2  + ny2  + nz2 

                                  nx =  nx/factor 
                                  ny =  ny/factor 
                                  nz =   nz/factor 

normalized      See normalize; after normalizing, a vector is normalized. 

normalized-device coordinates           The coordinate space used to represent 
      positions after division by the homogeneous clip coordinate before 
      transformation into window coordinates by the viewport transform. 

normalized value       A normalized value is one that lies between an 
      assumed range---for OpenGL, almost always meaning having a vector 
      length or absolute value of 1.0. See normalize. 

NURBS       Non-Uniform Rational B-Spline. A common way to specify 
      parametric curves and surfaces. 

object    An object-coordinate model that’s rendered as a collection of 
      primitives. 

object coordinates       Coordinate system prior to any OpenGL 
      transformation. 

occlusion query       A mechanism for determining if geometry is visible by 
      using the depth buffer (but not modifying its values). 

octave     The name given to the relationship of two functions when one 
      function’s frequency is twice the other function’s frequency. 

off-screen rendering       The process of drawing into a framebuffer that is 
      not directly displayed to the visible screen. 

The OpenGL Shading Language              The language used for authoring shader 
      program. Also commonly known as GLSL. 


        orthographic     Nonperspective (or parallel) projection, as in some 
              engineering drawings, with no foreshortening. 

        output-patch vertex     A vertex generated by the tessellation control shader. 
              These vertices generally form the control mesh of a patch. 

        overloading     As in C++, creating multiple functions with the same name 
              but with different parameters, allowing a compiler to generate 
              different signatures for the functions and call the correct version 
              based on its use. 

        pack    The process of converting pixel colors from a buffer into the format 
              requested by the application. 

        padding a structure     The addition of members (often unused) to a 
              structure---normally at the end---in order to ensure that it is a specific 
              size, or will be aligned on a specific boundary. 

        pass-through shader       A shader that performs no substantial work other 
              than to pass its inputs to its output. 

        patch    A high order surface representation made up of a number of 
              control points. Patches are used as the input to a tessellation control 
              shader, which executes once for each control point in the patch and 
              may generate a set of data for the patch to be used by the 
              fixed-function tessellator or the subsequent tessellation evaluation 
              shader. 

        Perlin noise    A form of noise invented by Ken Perlin designed to be 
              effective while not too computationally difficult for real-time 
              rendering. 

        perspective correction     An additional calculation for texture coordinates 
              to fix texturing artifacts for a textured geometric rendered in a 
              perspective projection. 

        perspective division     The division of x, y, and z by w, carried out in clip 
              coordinates. 

        Phong reﬂection model       An illumination model used for simulating 
              lighting effects in computer-generated images. 

        Phong shading      The coloring of pixels using the Phong reflection model 
              evaluated at every pixel of a geometric primitive. This is in 
              comparison to evaluating the Phong reflective model at the vertices, 
              and interpolating the computed colors across the geometric primitive. 

ping-pong buffers     A GPGPU technique of writing values to a buffer 
      (usually a texture map) that is immediately rebound as a texture map 
      to be read from to do a subsequent computation. Effectively, you can 
      consider the buffer written-to, and subsequently read-from as being a 
      collection of temporary values. Ping-ponging buffers is usually done 
      using framebuffer objects. 

pixel   Short for ‘‘picture element’’. The bits at location (x, y) of all the 
      bitplanes in the framebuffer constitute the single pixel  (x, y). In an 
      image in client memory, a pixel is one group of elements. In OpenGL 
      window coordinates, each pixel corresponds to a  1.0 × 1.0 screen 
      area. The coordinates of the lower left corner of the pixel are (x, y), 
      and of the upper right corner are (x + 1,y + 1). 

point   An exact location in space, which is rendered as a finite-diameter 
      dot. 

point fade threshold     The minimum value used in point rasterization 
      where point-antialiasing effects are disabled. 

point light source    See local light source. 

point sampling     Finding the color of a scene at specific points of zero size. 
      For example, deciding what color to turn a pixel based on the color of 
      the scene at the pixel’s center, or based on a finite number of point 
      samples within the pixel, as opposed to looking at the entire area the 
      pixel covers (see area sampling). 

polygon    A near-planar surface bounded by edges specified by vertices. 
      Each triangle of a triangle mesh is a polygon, as is each quadrilateral 
      of a quadrilateral mesh. 

polygon offset    A technique to modify depth-buffer values of a polygon 
      when additional geometric primitives are drawn with identical 
      geometric coordinates. 

positional light source    See local light source. 

primitive assembler     A component in graphics hardware that groups 
      vertices into points, lines, or triangles ready for rendering. The 
      primitive assembler may also perform tasks such as perspective 
      division and the viewport transform. 

primitive generator     See primitive assembler . 

procedural shading      Using shaders to create a surface texture, primarily 
      algorithmically (procedurally) rather than by doing texture lookups. 
      While side tables or maps may be stored and looked up as textures, 

              the bulk of the resources to create the desired effect come from 
              computation rather from a stored image. 

        procedural texture shader     A shader that helps perform procedural shading . 

        procedural texturing    See procedural shading . 

        programmable blending       The blending of colors under shader control, as 
              compared to OpenGL’s fixed-function blending operations. 

        programmable graphics pipeline       The mode of operation where the 
              processing of vertices, fragments, and their associated data (e.g., 
              texture coordinates) is under the control of shader programs specified 
              by the programmer. 

        projection matrix    The 4 × 4 matrix that transforms points, lines, 
              polygons, and raster positions from eye coordinates to clip 
              coordinates. 

        projective texturing   A texture-mapping technique that simualtes 
              projecting an image onto the objects in a scene. 

        protocol   A standard for interchanging messages between computer 
              systems. Some implementations of OpenGL use a protocol for 
              communicating between the client (usually the application) and the 
              server (usually the machine rendering OpenGL). 

        proxy texture   A placeholder for a texture image, which is used to 
              determine if there are enough resources to support a texture image of 
              a given size and internal format resolution. 

        pulse train   A sequence of pulses---usually equally spaced---used in 
              procedural shading techniques. 

        quadrilateral   A polygon with four edges. 

        race condition    A situation in multithreaded-application execution in 
              which two or more threads compete for the same resource, such as a 
              counter. The results of computations during a race condition are 
              unpredictable. 

        rasterization   Converts a projected point, line, or polygon, or the pixels of 
              a bitmap or image, to fragments, each corresponding to a pixel in the 
              framebuffer. Note that all primitives are rasterized, not just points, 
              lines, and polygons. 
rasterizer  The fixed function unit that converts a primitive (point, line, 
      or triangle) into a sequence of fragments ready for shading. The raste- 
      rizer performs rasterization. 

ray tracing   A family of algorithms that produce images or other outputs 
      by calculating the path of rays through media. 

rectangle   A quadrilateral whose alternate edges are parallel to each other 
      in object coordinates. 

render-to-texture   A technique where the storage for a texture map is used 
      as a destination for rendering (i.e., a renderbuffer). Render-to-texture 
      enables a more efficient method for updating texture maps than 
      rendering into the color buffer, and copy the results into texture 
      memory, saving the copy operation. 

renderbuffer    An allocation of memory in the OpenGL server for the 
      storage of pixel values. Renderbuffers are used as a destination for 
      rendering, as well as able to be as texture maps without requiring a 
      copy of the renderbuffer’s data. 

renderer   An OpenGL implementation in Apple Computer’s Mac OS X 
      operating system. Since a computer may have multiple 
      graphics-capable facilities (e.g., multiple graphics cards or a software 
      implementation), there may be multiple renderers supported on a 
      Mac OS X machine. 

rendering    The process of taking a representation of a scene in memory 
      and generating an image of that scene. 

rendering pipeline    The sequence of independent functions that together 
      implement rendering. This may be a set of both fixed-function and 
      programmable units. 

resident texture   A texture image that is cached in special, high- 
      performance texture memory. If an OpenGL implementation does 
      not have special, high-performance texture memory, then all texture 
      images are deemed resident textures. 

resolved   The process of combining pixel sample values (usually by a 
      weighted, linear combination) to the final pixel color. 

RGB color space     The three-dimensional color space commonly used for 
      computer graphic images, with one channel for each of the red, 
      green, and blue components. Other commonly used color spaces are 
      CMKY (in printing) and YUV (in video processing). 

RGBA     Red, Green, Blue, Alpha. 

         RGBA mode        An OpenGL context is in RGBA mode if its color buffers 
               store red, green, blue, and alpha color components, rather than color 
               indices. 

         sample     A subpixel entity used for multisampled antialiasing. A pixel can 
               store color (and potentially depth and stencil) data for multiple 
               samples. Before the final pixel is rendered on the screen, samples are 
               resolved into the final pixel color. 

         sample shader       A fragment shader that’s executed per pixel sample 
               location, allowing much finer-grain determination of a pixel’s color. 

         sampler object      An OpenGL object representing the state used to fetch 
               texture values from a texture map. 

         sampler variables      Variables used in shaders to represent references to 
               texture or sampler units. 

         samples     Independent color elements that make up a multisampled pixel 
               or texel. See also multisampling. 

         sampling     See point sampling . 

         scissor box     The rectangular region defining where the scissor test will be 
               applied to fragments. See scissoring. 

         scissoring     A fragment clipping test. Fragments outside of a rectangular 
               scissor region are rejected. 

         second-source blending         Blending that uses both the first and second 
               outputs from the fragment shader in the calculation of the final 
               fragment data. 

         selector    Part of the OpenGL state that stores the unit to be used for 
               subsequent operations on indexed state. For example, the active 
               texture unit is a selector. 

         server    The computer on which OpenGL commands are executed. This 
               might differ from the computer from which commands are issued. 
               See client. 

         shader    Executable programs that take as input data produced by one 
               stage of a pipeline (such as vertices, primitives, or fragments) and 
               produce a different type of data ready for consumption by the 
               subsequent stage in the pipeline. 

         shader plumbing       The administrative work involved in executing shaders. 
               This will include setting the values of uniforms, setting input and 
               output primitive types, defining interfaces, and so on. 

shader program     A set of instructions written in a graphics shading 
      language (the OpenGL Shading Language, also called GLSL) that 
      control the processing of graphics primitives. 

shader stage    A logical part of the shading pipeline that executes a 
      particular type of shader. A shader stage may not be a physically 
      separate execution unit in the OpenGL implementation; for example, 
      a hardware implementation may execute both vertex and geometry 
      shaders on the same execution engine. 

shader storage buffer objects     Render-time sizeable GLSL buffer objects 
      that can be read and written from within a shader. 

shader variable    A variable declared and used in a shader. 

shading    The process of interpolating color within the interior of a 
      polygon, or between the vertices of a line, during rasterization. 

shadow map      A texture map that contains information relating to the 
      locations of shadows within a scene. 

shadow mapping      A texture-mapping technique employing shadow maps, 
      to render geometric objects while simulating shadowing in the scene. 

shadow sampler      A sampler type that performs a comparison between the 
      sampled texels and a provided reference value, returning a value 
      between 0 .0 and 1.0 to indicate whether the fetched texel satisfies the 
      comparison condition. Commonly used in shadow mapping 
      algorithms. 

shadow texture     See shadow map. 

shared exponent     A numeric representation of a multicomponent 
      floating-point vector where components of the vector are packed 
      together into a single quantity containing a mantissa per component, 
      but with a single exponent value shared across all components. 

shininess   The exponent associated with specular reflection and lighting. 
      Shininess controls the degree with which the specular highlight 
      decays. 

singular matrix   A matrix that has no inverse. Geometrically, such a 
      matrix represents a transformation that collapses points along at least 
      one line to a single point. 

sky box   A representative piece of geometry---usually a cube---that 
      contains encompasses all other geometry in the scene, and is usually 
      texture mapped to look like the sky. 

         slice   An element of an array texture. 

         smooth shading       See Gouraud shading. 

         source-blending factor       The coefficient associated with the source color 
               (i.e., the color output from the fragment shader) used in blending 
               computations. 

         specular    Specular lighting and reflection incorporate reflection off shiny 
               objects and the position of the viewer. Maximum specular reflectance 
               occurs when the angle between the viewer and the direction of the 
               reflected light is zero. A specular material scatters light with greatest 
               intensity in the direction of the reflection, and its brightness decays, 
               based upon the exponential value shininess. 

         spotlight    A special type of local light source that has a direction (where it 
               points to) as well as a position. A spotlight simulates a cone of light, 
               which may have a fall-off in intensity, based upon distance from the 
               center of the cone. 

         sprite   A screen-aligned graphics primitive. Sprites are usually represented 
               as either a single vertex that is expanded to cover many pixels around 
               the transformed vertex, or as a quadrilateral its vertices specified so 
               that it is perpendicular to the viewing direction (or put another way, 
               parallel to the image plane). 

         sRGB color space       An RGB color space standard specified by the 
               International Electrotechnical Commission (IEC) that matches the 
               color intensity outputs of monitors and printers better than a linear 
               RGB space. The sRGB approximately corresponds to gamma 
               correcting RGB (but not alpha) values using a gamma value of 2.2. 
               See IEC standard 61966-2-1 for all of the gory details. 

         state   All of the variables that make up a part of an OpenGL context. For 
               example, texture, blending, and vertex attribute setup are considered 
               state. 

         stencil buffer   Memory (bitplanes) that is used for additional per- 
               fragment testing, along with the depth buffer. The stencil test may be 
               used for masking regions, capping solid geometry, and overlapping 
               translucent polygons. 

         stencil testing    Testing the value contained in the stencil buffer against 
               the current stencil reference value to determine if and how the 
               fragment should be written to the framebuffer. 
stereo   Enhanced three-dimensional perception of a rendered image by 
      computing separate images for each eye. Stereo requires special 
      hardware, such as two synchronized monitors or special glasses, to 
      alternate viewed frames for each eye. Some implementations of 
      OpenGL support stereo by including both left and right buffers for 
      color data. 

stipple  A one- or two-dimensional binary pattern that defeats the 
      generation of fragments where its value is zero. Line stipples are 
      one-dimensional and are applied relative to the start of a line. 
      Polygon stipples are two-dimensional and are applied with a fixed 
      orientation to the window. 

subpixel   The logical division of a physical pixel into subregions. See 
      sample. 

supersampling     Performing full per-sample rendering for multiple 
      samples per pixel, and then coloring the pixel based on the average 
      of the colors found for each sample in the pixel. 

surface normal    A surface normal vector at some pointis a vector pointing 
      in the direction perpendicular to the surface at that point. A three- 
      component normal vector can define theangular orientation of a 
      plane, but not its position. 

surface-local coordinate space     A coordinate system relative to a surface, 
      where no matter the true orientation of the surface, the surface is 
      taken to be the xy plane, and the normal to the surface is (0,0,1). 

surface-local coordinates    Coordinates relative to a surface-local coordinate 
      space. 

swizzle   Rearranging the components of a vector---for example, a texel or 
      vertex into a desired order. 

tangent space    The space of vectors tangent to a point. In general, 
      tangent space is the plane perpendicular to the normal vector at a 
      vertex. 

temporal aliasing    Aliasing artifacts that vary with time. 

tessellated   A patch is said to be tessellated after it has been broken down 
      into many primitives---often quads or triangles. 

tessellation control shader    A shader that executes in the tessellation 
      control stage and accepts as input the control points of a patch and 
      produces inner- and outer-tessellation factors for the patch and 
               per-patch parameters for consumption by the tessellation evaluation 
               shader. 

         tessellation coordinates      The generated barycentric coordinates within the 
               tessellation domain produced by the fixed-function tessellator and 
               provided to the tessellation evaluation shader. 

         tessellation domain      The domain over which a high-order-surface is 
               tessellated. This includes quad, triangle, and isoline domains. 

         tessellation evaluation shader       A shader that executes once per 
               tessellation output-patch vertex produced by the fixed-function 
               tessellator. 

         tessellation level factor    See tessellation levels. 

         tessellation levels    There are two tessellation levels associated with a 
               single patch primitive and that are generated by the tessellation 
               control shader. The inner tessellation factor controls by how much the 
               interior of a patch is tessellated. Additionally, each outer edge of the 
               patch has an associated outer tessellation factor that controls by how 
               much that edge is tessellated. 

         tessellation output patch vertices       The output vertices produced by the 
               tessellation control shader. 

         tessellation shaders      Collectively the tessellation control and tessellation 
               evaluation shaders. 

         texel   A texture element. A texel is obtained from texture memory and 
               represents the color of the texture to be applied to a corresponding 
               fragment. 

         texture comparison mode         A mode of texture mapping that evaluates a 
               comparison when sampling a texture map, as compared to directly 
               returning the sampled texel value. 

         texture coordinates      The coordinates used to fetch data from a texture 
               map. 

         texture ﬁlter   A color-smoothing operation applied when a texture map is 
               sampled. 

         texture map     See textures. 

         texture mapping      The process of applying an image (the texture) to a 
               primitive. Texture mapping is often used to add realism to a scene. 
               For example, you can apply a picture of a building facade to a 
               polygon representing a wall. 

texture object   A named cache that stores texture data, such as the image 
      array, associated mipmaps, and associated texture parameter values: 
      width, height, border width, internal format, resolution of 
      components, minification and magnification filters, wrapping 
      modes, border color, and texture priority. 

texture sampler    A variable used in a shader to sample from a texture. 

texture streaming    A technique where texture maps are updated at a 
      periodic frequency (e.g., one per frame). 

texture swizzle   See swizzle. 

texture targets   Often used in place of a texture type, the texture targets 
      include 1D, 2D, 3D, cube map, array forms, and so on. 

texture unit   When multitexturing, as part of an overall multiple pass 
      application of texture images, a texture unit controls one processing 
      step for a single texture image. A texture unit maintains the texturing 
      state for one texturing pass, including the texture image, filter, 
      environment, coordinate generation, and matrix stack. Multi- 
      texturing consists of a chain of texture units. 

texture view   A technique that interprets a single texture map’s data in 
      different formats. 

textures   One- or two-dimensional images that are used to modify the 
      color of fragments produced by rasterization. 

transform feedback object     The OpenGL object that contains post- 
      transform (e.g., after vertex-, tessellation-, or geometry shading) data. 

transformation matrices     Matrices that are used to transform vertices 
      from one coordinate space to another. 

transformations    The warping of spaces. In OpenGL, transformations are 
      limited to projective transformations that include anything that can 
      be represented by a 4 × 4 matrix. Such transformations include 
      rotations, translations, (nonuniform) scalings along the coordinate 
      axes, perspective transformations, and combinations of these. 

triangle  A polygon with three edges. Triangles are always convex. 

turbulence    A form of procedurally-generated noise that includes sharp 
      creases and cusps in the output image. 

typed array   A JavaScript construct for storing binary-typed data in a 
     JavaScript arrays. It’s required for use with WebGL. 

        undersampling      Choosing pixel colors to display by point sampling  at 
              intervals further apart than the detail in the scene to render. More 
              formally, it is sampling at less than double the frequency of the 
              highest frequencies present in the scene. Point sampling always 
              under samples edges, since edges are step functions containing 
              arbitrarily high frequencies. This results in aliasing. 

        uniform buffer object     A type of buffer object that encapsulates a set of 
              uniform variables, making access and update of that collection of 
              uniform variables much faster with less function call overhead. 

        uniform variable    A type of variable used in vertex or fragment shaders 
              that doesn’t change its value across a set of primitives (either a 
              single primitive, or the collection of primitives specified by a single 
              draw call). 

        unit square    A square that has a side length of one. 

        unpack     The process of converting pixels supplied by an application to 
              OpenGL’s internal format. 

        Utah teapot    The quintessential computer-graphics object. The Utah 
              teapot was originally modeled by Martin Newell at the University 
              of Utah. 

        value noise    A function-based noise generation technique. 

        vector    A multidimensional number often used to represent position, 
              velocity, or direction. 

        vertex   A point in three-dimensional space. 

        vertex array    A block of vertex data (vertex coordinates, texture 
              coordinates, surface normals, RGBA colors, color indices, and edge 
              flags) may be stored in an array and then used to specify multiple 
              geometric primitives through the execution of a single OpenGL 
              command. 

        vertex-array object    An object representing the state of a set of vertex 
              arrays. 

        vertex-attribute array    An array of data that will be used to form the 
              inputs to the vertex shader. 

        vertex shader     A shader that consumes as input vertices supplied by the 
              application and produces vertices for consumption by the subsequent 
              stage (tessellation control, geometry, or rasterization). 

vertex winding    The order of vertices that will be used to determine 
      whether a polygon is front facing or back facing. 

view volume    The volume in clip coordinates whose coordinates satisfy 
      the following three conditions: 

                                 −w < x < w 

                                 −w < y  < w 
                                 −w < z < w 

      Geometric primitives that extend outside this volume are clipped. 

viewing model    The conceptual model used for transforming 
      three-dimensional coordinates into two-dimensional screen 
      coordinates. 

viewpoint   The origin of either the eye- or the clip-coordinate system, 
      depending on context. (For example, when discussing lighting, the 
     viewpoint is the origin of the eye-coordinate system. When 
      discussing projection, the viewpoint is the origin of the 
      clip-coordinate system.) With a typical projection matrix, the 
      eye-coordinate and clip-coordinate origins are at the same location. 

viewport   A rectangular collection of pixels on the screen through which 
      the rendered scene will be seen. Goes hand-in-hand with depth-range 
      parameters (see depth range). 

voxel   An element of a volume. See also texel and pixel . 

winding    See vertex winding. 

window    A subregion of the framebuffer, usually rectangular, whose pixels 
      all have the same buffer configuration. An OpenGL context renders 
      to a single window at a time. 

window aligned     When referring to line segments or polygon edges, 
      implies that these are parallel to the window boundaries. (In 
      OpenGL, the window is rectangular, with horizontal and vertical 
      edges.) When referring to a polygon pattern, implies that the pattern 
      is fixed relative to the window origin. 

window coordinates     The pixel coordinate system of a window. 

wireframe    A representation of an object that contains line segments only. 
     Typically, the line segments indicate polygon edges. 

word aligned    A memory address is said to be word aligned if it is an 
      integer multiple of the machine word size. 
 work item     A single item of work within a workgroup. Also known as an 
              invocation. 

        workgroup      A group of work items that collectively operate on data. See 
              also global workgroup and local workgroup. 

        X Window System        A window system used by many of the machines on 
              which OpenGL is implemented. GLX is the name of the OpenGL 
              extension to the X Window System. (See Appendix F.) 

        z -buffer   See depth buffer. 

        z -buffering   See depth testing. 
			  
	  