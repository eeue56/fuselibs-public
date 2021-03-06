using Uno;
using Uno.UX;
using Uno.Diagnostics;
using Uno.Testing;
using Uno.Collections;
using Uno.Testing;
using FuseTest;

namespace Fuse
{

	public class ValueTests: TestBase
	{
		[Test]
		public void OperatorTest()
		{
			TestScalar(13.0f);
			TestScalar(13.0);
			TestScalar(13);
			TestScalar(float2(13.0f, 11));
			TestScalar(float3(13.0f, 11, 10));
			TestScalar(float4(13.0f, 11, 9, 23));
			TestScalar(new Size(13.0f, Unit.Points));
			TestScalar(new Size2(new Size(13.0f, Unit.Points), new Size(15.0f, Unit.Points)));
			TestScalar(Marshal.ToDouble("13.0"));
			TestScalar(Marshal.ToDouble("13."));
			TestScalar(Marshal.ToDouble("13"));

			TestVector(7.0f, float4(7.0f, 7.0f, 7.0f, 7.0f));
			TestVector(7.0, float4(7.0f, 7.0f, 7.0f, 7.0f));			
			TestVector(7, float4(7.0f, 7.0f, 7.0f, 7.0f));

			TestVector((Size)7.0f, float4(7.0f, 7.0f, 7.0f, 7.0f));
			TestVector(new Size2(7.0f, 8.0f), float4(7.0f, 8.0f, 7.0f, 8.0f));

			TestVector(float2(7.0f, 8.0f), float4(7.0f, 8.0f, 7.0f, 8.0f));
			TestVector(float3(7.0f, 8.0f, 9.0f), float4(7.0f, 8.0f, 9.0f, 1.0f));			
			TestVector(float4(7.0f, 8.0f, 9.0f, 10.0f), float4(7.0f, 8.0f, 9.0f, 10.0f));

			object v = new Size(13, Unit.Percent);
			Assert.AreEqual(13, Marshal.ToSize(v).Value);
			Assert.AreEqual(Unit.Percent, Marshal.ToSize(v).Unit);

			v = new Size2(new Size(14, Unit.Percent), new Size(15, Unit.Pixels));
			Assert.AreEqual(14, Marshal.ToSize(v).Value);
			Assert.AreEqual(Unit.Percent, Marshal.ToSize(v).Unit);
			var x = Marshal.ToSize2(v).X;
			Assert.AreEqual(14, x.Value);
			Assert.AreEqual(Unit.Percent, x.Unit);
			var y = Marshal.ToSize2(v).Y;
			Assert.AreEqual(15, y.Value);
			Assert.AreEqual(Unit.Pixels, y.Unit);
		}

		// Expects the incoming value to be an equivalent of double 13.0
		void TestScalar(object v)
		{
			Assert.AreEqual(13.0+51, Marshal.ToDouble(Marshal.Add(v, 51.0f)));
			Assert.AreEqual(13.0+51, Marshal.ToDouble(Marshal.Add(v, 51.0)));
			Assert.AreEqual(13.0+51, Marshal.ToDouble(Marshal.Add(v, 51)));

			Assert.AreEqual(13.0-51.0, Marshal.ToDouble(Marshal.Subtract(v, 51.0f)));
			Assert.AreEqual(13.0-51.0, Marshal.ToDouble(Marshal.Subtract(v, 51.0)));
			Assert.AreEqual(13.0-51.0, Marshal.ToDouble(Marshal.Subtract(v, 51)));

			Assert.AreEqual(13.0*51.0, Marshal.ToDouble(Marshal.Multiply(v, 51.0f)));
			Assert.AreEqual(13.0*51.0, Marshal.ToDouble(Marshal.Multiply(v, 51.0)));
			Assert.AreEqual(13.0*51.0, Marshal.ToDouble(Marshal.Multiply(v, 51)));

			Assert.AreEqual(13.0/51.0, Marshal.ToDouble(Marshal.Divide(v, 51.0f)));
			Assert.AreEqual(13.0/51.0, Marshal.ToDouble(Marshal.Divide(v, 51.0)));
			Assert.AreEqual(13.0/51.0, Marshal.ToDouble(Marshal.Divide(v, 51)));
		}

		// Expects the incoming value to be equivalent of the given reference vector
		void TestVector(object v, float4 r)
		{
			var f = float4(8, 1, 3, 4);
			var k = f;
			Assert.AreEqual(f+r, Marshal.ToFloat4(Marshal.Add(k, v)));
			Assert.AreEqual(f-r, Marshal.ToFloat4(Marshal.Subtract(k, v)));
			Assert.AreEqual(f*r, Marshal.ToFloat4(Marshal.Multiply(k, v)));
			Assert.AreEqual(f/r, Marshal.ToFloat4(Marshal.Divide(k, v)));

			Assert.AreEqual((f+r).XYZ, Marshal.ToFloat3(Marshal.Add(k, v)));
			Assert.AreEqual((f-r).XYZ, Marshal.ToFloat3(Marshal.Subtract(k, v)));
			Assert.AreEqual((f*r).XYZ, Marshal.ToFloat3(Marshal.Multiply(k, v)));
			Assert.AreEqual((f/r).XYZ, Marshal.ToFloat3(Marshal.Divide(k, v)));

			Assert.AreEqual((f+r).XY, Marshal.ToFloat2(Marshal.Add(k, v)));
			Assert.AreEqual((f-r).XY, Marshal.ToFloat2(Marshal.Subtract(k, v)));
			Assert.AreEqual((f*r).XY, Marshal.ToFloat2(Marshal.Multiply(k, v)));
			Assert.AreEqual((f/r).XY, Marshal.ToFloat2(Marshal.Divide(k, v)));

			Assert.AreEqual((f+r).X, Marshal.ToFloat(Marshal.Add(k, v)));
			Assert.AreEqual((f-r).X, Marshal.ToFloat(Marshal.Subtract(k, v)));
			Assert.AreEqual((f*r).X, Marshal.ToFloat(Marshal.Multiply(k, v)));
			Assert.AreEqual((f/r).X, Marshal.ToFloat(Marshal.Divide(k, v)));

			var vr = r;
			Assert.AreEqual(r+Marshal.ToFloat4(v), Marshal.ToFloat4(Marshal.Add(vr, v)));
			Assert.AreEqual(r-Marshal.ToFloat4(v), Marshal.ToFloat4(Marshal.Subtract(vr, v)));
			Assert.AreEqual(r*Marshal.ToFloat4(v), Marshal.ToFloat4(Marshal.Multiply(vr, v)));
			Assert.AreEqual(r/Marshal.ToFloat4(v), Marshal.ToFloat4(Marshal.Divide(vr, v)));

			Assert.AreEqual(new Size2(r.X, r.Y), Marshal.ToSize2(v));
			Assert.AreEqual(new Size(r.X, Unit.Unspecified), Marshal.ToSize(v));

		}
	}
}