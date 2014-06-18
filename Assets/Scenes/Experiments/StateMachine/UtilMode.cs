using System;
using System.Collections.Generic;
//using System.Linq;
using System.Text;
//using System.Reflection;

namespace Util
{
	public class Mode<T, ID>
	{
		T mObj;
		Type mModeIDType;
		
		delegate void ModeFunc();
		
		ModeFunc[] mInitFunc;
		ModeFunc[] mProcFunc;
		ModeFunc[] mTermFunc;
		
		int mPrev = -1;
		int mCurr = -1;
		
		public Mode(T ob)
		{
			mObj = ob;
			mModeIDType = typeof(ID);
			SetUp();
			mCurr = 0;
		}
		
		void SetUp()
		{
			if (mModeIDType.IsEnum)
			{
				Array ary = Enum.GetValues(mModeIDType);
				int len = ary.Length;
				mInitFunc = new ModeFunc[len];
				mProcFunc = new ModeFunc[len];
				mTermFunc = new ModeFunc[len];
				
				foreach (int enumVal in ary)
				{
					string enumName =  Enum.GetName(mModeIDType, enumVal);
					mInitFunc[enumVal] = (ModeFunc) Delegate.CreateDelegate(typeof(ModeFunc), mObj, enumName + "_Init", false, false);
					mProcFunc[enumVal] = (ModeFunc) Delegate.CreateDelegate(typeof(ModeFunc), mObj, enumName + "_Proc", false, false);
					mTermFunc[enumVal] = (ModeFunc) Delegate.CreateDelegate(typeof(ModeFunc), mObj, enumName + "_Term", false, false);
				}
			}
			
		}
		
		public void Init(Enum modeID)
		{
			Set(modeID);
			init();
		}
		
		public void Proc()
		{
			while(mPrev != mCurr)
			{
				term();
				init();
			}
			proc();
		}
		
		public void Term()
		{
			term();
		}
		
		
		void init()
		{
			if (mCurr != -1)
			{
				mPrev = mCurr;
				if(mInitFunc[mCurr] != null) mInitFunc[mCurr]();
			}
		}
		void proc()
		{
			if(mProcFunc[mCurr] != null) mProcFunc[mCurr]();
		}
		void term()
		{
			if (mPrev != -1)
			{
				if(mTermFunc[mPrev] != null) mTermFunc[mPrev]();
			}
			mPrev = -1;
		}
		
		public static Mode<T, ID> operator ++(Mode<T, ID> mode)
		{
			++mode.mCurr;
			return mode;
		}
		
		public Mode<T, ID> Set(Enum modeID)
		{
			mCurr = (int)(ValueType)modeID;
			return this;
		}
		
		public int Get()
		{
			return mCurr;
		}
	}
}
