using Uno;
using Uno.UX;

using Fuse.Drawing;

namespace Fuse.Controls
{
	/**
		Performs the default layout on the children, where all children get all available space.

		Children of a Panel will by default fill its entire space. If a panel contains several children, it simply layers them on top of each other. Combining this behavior with @Alignment, @Margin and @Padding can be quite useful in many situations.
		
		Panels are assumed to be containers for other elements. Setting the `Color` property will therefore
		set the @Background property to a @SolidColor fill.
		
		**Note:** the element order in a Panel is the same as the layer order in popular graphics packages such as Photoshop; the layer that appears first in the UX-file will be layered on top of elements appearing later in the file.
		
		# Example
		
		This example demonstrates a simple `Panel` with a couple of overlapping children, and many of the properties often used with `Panel` set:

			<Panel Margin="10" Padding="2,4,6,8" Color="#444">
				<Text>This child will be drawn over the other child</Text>
				<Rectangle Color="#eee" />
			</Panel>

	*/
	public partial class Panel: LayoutControl, ISurfaceDrawable
	{
		[UXOriginSetter("SetColor")]
		/**
			The background color of the panel.
			This property is a shortcut for setting the `Background` property to a `SolidColor` brush. Supports being set using a `float4` notation, or hexadecimal values(f.ex `#FF00AA`)

			The following notations are supported:

			* HEX RGBA - `#FFFFFFFF` (and its shorthand `#FFFF`)
			* HEX RGBA - `#FFFFFF` (and its shorthand `#FFF`). Alpha is assumed to be `0xFF` / **255**
			* float4 values - `1,1,1,1` (every digit ranges from `0` to `1`)
		*/
		public float4 Color
		{
			get { return Get(FastProperty2.Color, float4(0)); }
			set { SetColor(value, this); }
		}

		public void SetColor(float4 value, IPropertyListener origin)
		{
			if (Color != value)
			{
				Set(FastProperty2.Color, value, float4(0));
				OnColorChanged(value, origin);
			}
		}

		public static readonly Selector ColorPropertyName = "Color";

		void OnColorChanged(float4 value, IPropertyListener origin)
		{
			OnPropertyChanged(ColorPropertyName, origin as IPropertyListener);

			if (!(Background is SolidColor))
	 			Background = new SolidColor(value);
	 		else
	 			((SolidColor)Background).Color = value;
		}
		
		//Common Mixin to expose LayoutControl.ISurfaceDrawable
		void ISurfaceDrawable.Draw(Surface surface)
		{
			ISurfaceDrawableDraw(surface);
		}
		//End-Mixin
		
		protected override void OnRooted()
		{
			base.OnRooted();
			SurfaceRooted(false);
			FreezeRooted();
		}
		
		protected override void OnUnrooted()
		{
			FreezeUnrooted();
			SurfaceUnrooted();
			base.OnUnrooted();
		}
	}
}
