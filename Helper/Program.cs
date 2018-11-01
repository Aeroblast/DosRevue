using System;
using System.IO;
namespace Helper
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0) { Console.WriteLine("usage: helper bmppath "); return; }
            if (File.Exists(args[0]))
            {
                Byte[] dt = File.ReadAllBytes(args[0]);
                Byte[] _offset = QuatByte(dt, 0xa);
                Byte[] _width = QuatByte(dt, 0x12);
                Byte[] _height = QuatByte(dt, 0x16);
                UInt32 offset = BitConverter.ToUInt32(_offset);
                Int32 width=BitConverter.ToInt32(_width);
                Int32 height=BitConverter.ToInt32(_height);
                int length=Math.Abs(width*height);
                Byte[] save= new Byte[length];
                for(int i=0;i<length;i++)
                {
                    save[i]=dt[offset+i];
                }
                Console.WriteLine("{0}*{1}",width,-height);
                File.WriteAllBytes(Path.GetFileNameWithoutExtension(args[0])+".ddb",save);
            }
        }
        static Byte[] QuatByte(Byte[] a, int offset)
        {
            Byte[] b = new Byte[4];
            b[0] = a[offset];
            b[1] = a[offset + 1];
            b[2] = a[offset + 2];
            b[3] = a[offset + 3];
            return b;
        }
    }
}
